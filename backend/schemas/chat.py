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


"""
Habit Streak Pydantic schemas
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class HabitStreakCreate(BaseModel):
    habit_name: str = Field(..., min_length=1, max_length=100)
    target_frequency: Optional[str] = Field("daily", pattern="^(daily|weekly)$")


class HabitStreakResponse(BaseModel):
    id: str
    user_id: str
    habit_name: str
    current_streak: int
    best_streak: int
    last_completed: Optional[datetime]
    target_frequency: Optional[str]
    created_at: datetime

    class Config:
        from_attributes = True


class HabitStreakUpdate(BaseModel):
    habit_name: Optional[str] = Field(None, min_length=1, max_length=100)
    target_frequency: Optional[str] = Field(None, pattern="^(daily|weekly)$")


"""
Heart Rate Log Pydantic schemas
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class HeartRateLogCreate(BaseModel):
    timestamp: datetime
    bpm: int = Field(..., ge=30, le=250)
    source: Optional[str] = Field(None, pattern="^(manual|watch|chest-strap)$")
    activity: Optional[str] = Field(None, pattern="^(resting|running|sleeping|other)$")


class HeartRateLogResponse(BaseModel):
    id: str
    user_id: str
    timestamp: datetime
    bpm: int
    source: Optional[str]
    activity: Optional[str]
    created_at: datetime

    class Config:
        from_attributes = True