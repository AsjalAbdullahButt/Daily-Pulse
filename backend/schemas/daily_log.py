"""
Daily Log Pydantic schemas
"""
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import date, datetime


class MealEntry(BaseModel):
    name: str
    time: Optional[str] = None
    calories: Optional[int] = None
    notes: Optional[str] = None


class DailyLogCreate(BaseModel):
    date: date
    steps: Optional[int] = Field(0, ge=0)
    sleep_hours: Optional[float] = Field(None, ge=0, le=24)
    sleep_quality: Optional[int] = Field(None, ge=1, le=10)
    water_ml: Optional[int] = Field(0, ge=0)
    meals: Optional[List[MealEntry]] = None
    mood: Optional[str] = Field(None, pattern="^(happy|neutral|sad|anxious|energetic|tired)$")
    notes: Optional[str] = None
    calories_consumed: Optional[int] = Field(None, ge=0)
    calories_burned: Optional[int] = Field(None, ge=0)


class DailyLogUpdate(BaseModel):
    steps: Optional[int] = Field(None, ge=0)
    sleep_hours: Optional[float] = Field(None, ge=0, le=24)
    sleep_quality: Optional[int] = Field(None, ge=1, le=10)
    water_ml: Optional[int] = Field(None, ge=0)
    meals: Optional[List[MealEntry]] = None
    mood: Optional[str] = Field(None, pattern="^(happy|neutral|sad|anxious|energetic|tired)$")
    notes: Optional[str] = None
    calories_consumed: Optional[int] = Field(None, ge=0)
    calories_burned: Optional[int] = Field(None, ge=0)


class DailyLogResponse(BaseModel):
    id: str
    user_id: str
    date: date
    steps: int
    sleep_hours: Optional[float]
    sleep_quality: Optional[int]
    water_ml: int
    meals: Optional[List[MealEntry]]
    mood: Optional[str]
    notes: Optional[str]
    calories_consumed: Optional[int]
    calories_burned: Optional[int]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class DailyLogDateRange(BaseModel):
    start_date: date
    end_date: date