"""
Chat Routes - AI chat assistant with WebSocket support
"""
from fastapi import APIRouter, Depends, HTTPException, status, WebSocket, WebSocketDisconnect
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from database.database import get_db
from models.user import User
from models.chat_history import ChatHistory
from models.daily_log import DailyLog
from schemas.chat import ChatMessage, ChatResponse, WebSocketMessage, WebSocketResponse
from services.auth import get_current_user, decode_token
from services.gemini_service import gemini_service
from datetime import datetime, date
from typing import List, Dict, Any
from loguru import logger

router = APIRouter(prefix="/api/chat", tags=["Chat Assistant"])


@router.post("/send", response_model=ChatResponse)
async def send_message(
    message: ChatMessage,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Send a message to the AI assistant and get a response.
    """
    # Get recent chat history for context
    history_result = await db.execute(
        select(ChatHistory)
        .where(ChatHistory.user_id == current_user.id)
        .order_by(ChatHistory.timestamp.desc())
        .limit(20)
    )
    recent_history = list(history_result.scalars().all())
    recent_history.reverse()  # chronological order
    
    # Format history for Gemini
    chat_history = []
    for h in recent_history:
        chat_history.append({"role": "user", "parts": [h.message]})
        chat_history.append({"role": "model", "parts": [h.response]})
    
    # Get today's log for context
    today_result = await db.execute(
        select(DailyLog).where(
            DailyLog.user_id == current_user.id,
            DailyLog.date == date.today(),
        )
    )
    today_log = today_result.scalar_one_or_none()
    
    # Build user context
    user_context = {
        "name": current_user.name,
        "age": current_user.age,
        "weight_kg": current_user.weight_kg,
        "height_cm": current_user.height_cm,
        "today_steps": today_log.steps if today_log else 0,
        "today_water_ml": today_log.water_ml if today_log else 0,
        "today_mood": today_log.mood if today_log else "unknown",
    }
    
    # Load system prompt
    system_prompt = _load_chat_prompt()
    
    # Generate response
    response = await gemini_service.chat_with_context(
        message=message.message,
        chat_history=chat_history,
        system_instruction=system_prompt,
        user_context=user_context,
    )
    
    # Extract any structured data from response
    extracted_data = _extract_data_from_response(response["text"])
    
    # Save to database
    chat_entry = ChatHistory(
        user_id=current_user.id,
        message=message.message,
        response=response["text"],
        role="user",
        extracted_data=extracted_data,
        tokens_used=response.get("tokens_used", 0),
        model_used="gemini-flash",
    )
    db.add(chat_entry)
    await db.flush()
    
    return ChatResponse(
        id=chat_entry.id,
        response=response["text"],
        extracted_data=extracted_data,
        timestamp=chat_entry.timestamp,
    )


@router.get("/history", response_model=List[ChatResponse])
async def get_chat_history(
    limit: int = 50,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get chat history for current user.
    """
    result = await db.execute(
        select(ChatHistory)
        .where(ChatHistory.user_id == current_user.id)
        .order_by(ChatHistory.timestamp.desc())
        .limit(limit)
    )
    history = result.scalars().all()
    
    return [
        ChatResponse(
            id=h.id,
            response=h.message + "\n\n---\n\n" + h.response,
            extracted_data=h.extracted_data,
            timestamp=h.timestamp,
        )
        for h in reversed(history)
    ]


@router.websocket("/ws/{user_id}")
async def websocket_chat(websocket: WebSocket, user_id: str):
    """
    WebSocket endpoint for real-time chat.
    """
    await websocket.accept()
    
    # Verify token from query params
    token = websocket.query_params.get("token")
    if not token:
        await websocket.close(code=4001, reason="Missing authentication token")
        return
    
    try:
        payload = decode_token(token, token_type="access")
        if payload.get("sub") != user_id:
            await websocket.close(code=4003, reason="Unauthorized")
            return
    except Exception:
        await websocket.close(code=4001, reason="Invalid token")
        return
    
    logger.info(f"WebSocket connected: user_id={user_id}")
    
    try:
        while True:
            # Receive message
            data = await websocket.receive_text()
            message_data = WebSocketMessage.model_validate_json(data)
            
            # Get database session
            from database.database import AsyncSessionLocal
            async with AsyncSessionLocal() as db:
                # Get user
                result = await db.execute(select(User).where(User.id == user_id))
                user = result.scalar_one_or_none()
                
                if not user:
                    await websocket.send_json({"error": "User not found"})
                    continue
                
                # Get chat history
                history_result = await db.execute(
                    select(ChatHistory)
                    .where(ChatHistory.user_id == user_id)
                    .order_by(ChatHistory.timestamp.desc())
                    .limit(20)
                )
                recent_history = list(history_result.scalars().all())
                recent_history.reverse()
                
                chat_history = []
                for h in recent_history:
                    chat_history.append({"role": "user", "parts": [h.message]})
                    chat_history.append({"role": "model", "parts": [h.response]})
                
                # Get today's log
                today_result = await db.execute(
                    select(DailyLog).where(
                        DailyLog.user_id == user_id,
                        DailyLog.date == date.today(),
                    )
                )
                today_log = today_result.scalar_one_or_none()
                
                user_context = {
                    "name": user.name,
                    "age": user.age,
                    "weight_kg": user.weight_kg,
                    "height_cm": user.height_cm,
                    "today_steps": today_log.steps if today_log else 0,
                    "today_water_ml": today_log.water_ml if today_log else 0,
                    "today_mood": today_log.mood if today_log else "unknown",
                }
                
                system_prompt = _load_chat_prompt()
                
                response = await gemini_service.chat_with_context(
                    message=message_data.text,
                    chat_history=chat_history,
                    system_instruction=system_prompt,
                    user_context=user_context,
                )
                
                extracted_data = _extract_data_from_response(response["text"])
                
                # Save to database
                chat_entry = ChatHistory(
                    user_id=user_id,
                    message=message_data.text,
                    response=response["text"],
                    role="user",
                    extracted_data=extracted_data,
                    tokens_used=response.get("tokens_used", 0),
                    model_used="gemini-flash",
                )
                db.add(chat_entry)
                await db.commit()
                
                # Send response
                ws_response = WebSocketResponse(
                    assistant_response=response["text"],
                    extracted_data=extracted_data,
                    timestamp=datetime.utcnow(),
                )
                await websocket.send_json(ws_response.model_dump(mode="json"))
    
    except WebSocketDisconnect:
        logger.info(f"WebSocket disconnected: user_id={user_id}")
    except Exception as e:
        logger.error(f"WebSocket error: {e}")
        await websocket.close(code=1011, reason="Internal server error")


def _load_chat_prompt() -> str:
    """Load chat assistant system prompt"""
    try:
        with open("prompts/chat_assistant.md", "r") as f:
            return f.read()
    except FileNotFoundError:
        return """You are Daily Pulse AI, a friendly health assistant embedded in a wellness app.

Your primary role is to help users log their daily health data through natural conversation.
When users mention activities, extract the relevant information and help them track it.

You can help with:
- Logging steps, sleep, water intake, meals, and mood
- Providing health tips and encouragement
- Answering questions about their wellness data
- Suggesting healthy habits

When you detect loggable data in their message, respond naturally AND include a JSON block like:
```json
{"type": "log_update", "data": {"steps": 5000, "water_ml": 500}}
```

Always be supportive, encouraging, and helpful. Keep responses concise and friendly."""


def _extract_data_from_response(response_text: str) -> Dict[str, Any]:
    """Extract structured data from AI response if present"""
    import json
    import re
    
    # Look for JSON blocks in response
    json_pattern = r'```json\s*(.*?)\s*```'
    matches = re.findall(json_pattern, response_text, re.DOTALL)
    
    for match in matches:
        try:
            data = json.loads(match)
            if isinstance(data, dict) and "type" in data:
                return data
        except json.JSONDecodeError:
            continue
    
    return None