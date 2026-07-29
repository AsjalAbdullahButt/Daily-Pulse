"""
Chat History database model
"""
import uuid
from datetime import datetime
from sqlalchemy import Column, String, Text, DateTime, ForeignKey, JSON
from sqlalchemy.dialects.mysql import CHAR
from sqlalchemy.orm import relationship
from database.database import Base


class ChatHistory(Base):
    __tablename__ = "chat_history"

    id = Column(CHAR(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(CHAR(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    message = Column(Text, nullable=False)
    response = Column(Text, nullable=False)
    role = Column(String(20), nullable=False, default="user")  # user or assistant
    extracted_data = Column(JSON, nullable=True)  # Structured data extracted from message
    tokens_used = Column(Integer, nullable=True)
    model_used = Column(String(50), nullable=True)  # gemini-flash, gemini-pro, etc.
    timestamp = Column(DateTime, default=datetime.utcnow, index=True)

    # Relationships
    user = relationship("User", back_populates="chat_history")