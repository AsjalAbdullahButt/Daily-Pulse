"""
Running Session Pydantic schemas
"""
from pydantic import BaseModel, Field
from typing import Optional, Dict, Any
from datetime import datetime


class RunningSessionCreate(BaseModel):
    date: datetime
    distance_km: float = Field(..., gt=0, description="Distance in kilometers")
    duration_seconds: int = Field(..., gt=0, description="Duration in seconds")
    avg_pace: Optional[float] = Field(None, ge=0, description="Avg pace (min/km)")
    max_speed: Optional[float] = Field(None, ge=0, description="Max speed (km/h)")
    route_geojson: Optional[Dict[str, Any]] = None
    calories_burned: Optional[int] = Field(None, ge=0)
    elevation_gain: Optional[float] = Field(None, ge=0, description="Meters")
    avg_heart_rate: Optional[int] = Field(None, ge=30, le=250)
    notes: Optional[str] = None


class RunningSessionResponse(BaseModel):
    id: str
    user_id: str
    date: datetime
    distance_km: float
    avg_pace: Optional[float]
    max_speed: Optional[float]
    duration_seconds: int
    route_geojson: Optional[Dict[str, Any]]
    calories_burned: Optional[int]
    elevation_gain: Optional[float]
    avg_heart_rate: Optional[int]
    notes: Optional[str]
    created_at: datetime

    class Config:
        from_attributes = True


class RunningStats(BaseModel):
    total_distance_km: float
    total_sessions: int
    avg_distance: float
    best_distance: float
    total_duration_seconds: int
    avg_pace: Optional[float]