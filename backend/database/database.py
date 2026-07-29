"""
Database configuration for Daily Pulse Backend
Uses SQLAlchemy async with MySQL (asyncmy driver)
"""
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import text
from typing import AsyncGenerator
import os
from dotenv import load_dotenv

load_dotenv()

# Database URL - MySQL with asyncmy driver
# Format: mysql+asyncmy://username:password@host:port/database_name
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "mysql+asyncmy://root:password@localhost:3306/daily_pulse"
)

# Create async engine
engine = create_async_engine(
    DATABASE_URL,
    echo=os.getenv("SQL_ECHO", "false").lower() == "true",
    pool_size=20,
    max_overflow=10,
    pool_pre_ping=True,
    pool_recycle=3600,
)

# Create async session factory
AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
)


class Base(DeclarativeBase):
    """Base class for all SQLAlchemy models"""
    pass


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """
    Dependency that provides a database session.
    Handles commit/rollback automatically.
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()


async def init_db():
    """
    Initialize database - create tables if they don't exist.
    """
    async with engine.begin() as conn:
        # Import all models to register them with Base
        from models.user import User
        from models.daily_log import DailyLog
        from models.running_session import RunningSession
        from models.chat_history import ChatHistory
        from models.habit_streak import HabitStreak
        from models.heart_rate_log import HeartRateLog
        
        # Create all tables
        await conn.run_sync(Base.metadata.create_all)


async def check_db_connection() -> bool:
    """
    Check if database connection is healthy.
    """
    try:
        async with AsyncSessionLocal() as session:
            await session.execute(text("SELECT 1"))
            return True
    except Exception:
        return False