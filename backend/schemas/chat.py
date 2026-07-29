"""
Chat History Pydantic schemas
"""
from pydantic import BaseModel, Field
from typing import Optional, Dict, Any
from datetime import datetime


class ChatMessage(BaseModel):
    message: str = Field(..., min_length=1, max_length=5000)


class ChatResponse(BaseModel):
    id: str
    response: str
    extracted_data: Optional[Dict[str, Any]]
    timestamp: datetime

    class Config:
        from_attributes = True


class ChatHistoryResponse(BaseModel):
    messages: list[ChatMessage]
    total: int


class WebSocketMessage(BaseModel):
    text: str


class WebSocketResponse(BaseModel):
    assistant_response: str
    extracted_data: Optional[Dict[str, Any]] = None
    timestamp: datetime
