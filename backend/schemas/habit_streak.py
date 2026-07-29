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
