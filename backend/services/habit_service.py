"""
Habit Service - Streak tracking and management
"""
from typing import Optional, List
from datetime import datetime, date
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_
from models.habit_streak import HabitStreak
from models.daily_log import DailyLog
from loguru import logger


class HabitService:
    """Service for managing habit streaks"""

    async def get_user_habits(
        self,
        db: AsyncSession,
        user_id: str,
    ) -> List[HabitStreak]:
        """Get all habits for a user"""
        result = await db.execute(
            select(HabitStreak).where(HabitStreak.user_id == user_id)
        )
        return list(result.scalars().all())

    async def create_habit(
        self,
        db: AsyncSession,
        user_id: str,
        habit_name: str,
        target_frequency: str = "daily",
    ) -> HabitStreak:
        """Create a new habit"""
        habit = HabitStreak(
            user_id=user_id,
            habit_name=habit_name,
            target_frequency=target_frequency,
            current_streak=0,
            best_streak=0,
        )
        db.add(habit)
        await db.flush()
        return habit

    async def update_habit(
        self,
        db: AsyncSession,
        habit_id: str,
        user_id: str,
        habit_name: Optional[str] = None,
        target_frequency: Optional[str] = None,
    ) -> Optional[HabitStreak]:
        """Update habit details"""
        result = await db.execute(
            select(HabitStreak).where(
                HabitStreak.id == habit_id,
                HabitStreak.user_id == user_id,
            )
        )
        habit = result.scalar_one_or_none()
        
        if not habit:
            return None

        if habit_name is not None:
            habit.habit_name = habit_name
        if target_frequency is not None:
            habit.target_frequency = target_frequency

        await db.flush()
        return habit

    async def delete_habit(
        self,
        db: AsyncSession,
        habit_id: str,
        user_id: str,
    ) -> bool:
        """Delete a habit"""
        result = await db.execute(
            select(HabitStreak).where(
                HabitStreak.id == habit_id,
                HabitStreak.user_id == user_id,
            )
        )
        habit = result.scalar_one_or_none()
        
        if not habit:
            return False

        await db.delete(habit)
        return True

    async def mark_habit_complete(
        self,
        db: AsyncSession,
        habit_id: str,
        user_id: str,
    ) -> Optional[HabitStreak]:
        """Mark a habit as completed for today, updating streak"""
        result = await db.execute(
            select(HabitStreak).where(
                HabitStreak.id == habit_id,
                HabitStreak.user_id == user_id,
            )
        )
        habit = result.scalar_one_or_none()
        
        if not habit:
            return None

        now = datetime.utcnow()
        today = now.date()

        # Check if already completed today
        if habit.last_completed and habit.last_completed.date() == today:
            return habit  # Already completed today

        # Update streak
        if habit.last_completed:
            last_date = habit.last_completed.date()
            days_diff = (today - last_date).days
            
            if habit.target_frequency == "daily" and days_diff == 1:
                # Consecutive day
                habit.current_streak += 1
            elif habit.target_frequency == "weekly" and days_diff <= 7:
                # Within weekly target
                habit.current_streak += 1
            else:
                # Streak broken
                habit.current_streak = 1
        else:
            # First completion
            habit.current_streak = 1

        # Update best streak
        if habit.current_streak > habit.best_streak:
            habit.best_streak = habit.current_streak

        habit.last_completed = now
        await db.flush()
        return habit

    async def check_habits_from_daily_log(
        self,
        db: AsyncSession,
        user_id: str,
        daily_log: DailyLog,
    ) -> List[HabitStreak]:
        """
        Automatically check habits based on daily log data.
        """
        updated_habits = []
        habits = await self.get_user_habits(db, user_id)
        
        for habit in habits:
            habit_lower = habit.habit_name.lower()
            completed = False

            # Auto-check common habits based on log data
            if "water" in habit_lower and daily_log.water_ml >= 2000:
                completed = True
            elif "steps" in habit_lower and daily_log.steps >= 8000:
                completed = True
            elif "sleep" in habit_lower and daily_log.sleep_hours and daily_log.sleep_hours >= 7:
                completed = True
            elif "mood" in habit_lower and daily_log.mood in ["happy", "energetic"]:
                completed = True

            if completed:
                updated = await self.mark_habit_complete(db, habit.id, user_id)
                if updated:
                    updated_habits.append(updated)

        return updated_habits


# Singleton instance
habit_service = HabitService()