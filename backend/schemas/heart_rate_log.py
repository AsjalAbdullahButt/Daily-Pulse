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
