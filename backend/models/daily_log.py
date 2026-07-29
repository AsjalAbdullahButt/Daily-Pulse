"""
Daily Log database model
"""
import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, Integer, Float, DateTime, Date, ForeignKey, JSON, Text
from sqlalchemy.dialects.mysql import CHAR
from sqlalchemy.orm import relationship
from database.database import Base


class DailyLog(Base):
    __tablename__ = "daily_logs"

    id = Column(CHAR(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(CHAR(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    date = Column(Date, nullable=False, index=True)
    steps = Column(Integer, default=0)
    sleep_hours = Column(Float, nullable=True)
    sleep_quality = Column(Integer, nullable=True)  # 1-10 scale
    water_ml = Column(Integer, default=0)
    meals = Column(JSON, nullable=True)  # Array of meal entries
    mood = Column(String(50), nullable=True)  # happy, neutral, sad, anxious, energetic
    notes = Column(Text, nullable=True)
    calories_consumed = Column(Integer, nullable=True)
    calories_burned = Column(Integer, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="daily_logs")

    __table_args__ = (
        # Unique constraint: one log per user per day
        {'mysql_engine': 'InnoDB'}
    )