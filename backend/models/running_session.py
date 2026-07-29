"""
Running Session database model
"""
import uuid
from datetime import datetime
from sqlalchemy import Column, String, Integer, Float, DateTime, ForeignKey, JSON, Text
from sqlalchemy.dialects.mysql import CHAR
from sqlalchemy.orm import relationship
from database.database import Base


class RunningSession(Base):
    __tablename__ = "running_sessions"

    id = Column(CHAR(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(CHAR(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    date = Column(DateTime, nullable=False, index=True)
    distance_km = Column(Float, nullable=False)
    avg_pace = Column(Float, nullable=True)  # minutes per km
    max_speed = Column(Float, nullable=True)  # km/h
    duration_seconds = Column(Integer, nullable=False)
    route_geojson = Column(JSON, nullable=True)  # GeoJSON format
    calories_burned = Column(Integer, nullable=True)
    elevation_gain = Column(Float, nullable=True)  # meters
    avg_heart_rate = Column(Integer, nullable=True)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="running_sessions")