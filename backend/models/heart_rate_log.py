"""
Heart Rate Log database model
"""
import uuid
from datetime import datetime
from sqlalchemy import Column, String, Integer, DateTime, ForeignKey
from sqlalchemy.dialects.mysql import CHAR
from sqlalchemy.orm import relationship
from database.database import Base


class HeartRateLog(Base):
    __tablename__ = "heart_rate_logs"

    id = Column(CHAR(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(CHAR(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    timestamp = Column(DateTime, nullable=False, index=True)
    bpm = Column(Integer, nullable=False)
    source = Column(String(50), nullable=True)  # manual, watch, chest-strap
    activity = Column(String(100), nullable=True)  # resting, running, sleeping
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="heart_rate_logs")