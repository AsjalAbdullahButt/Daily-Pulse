"""
Insights Service - AI-powered health analysis and recommendations
"""
from typing import Optional, Dict, Any, List
from datetime import date, timedelta
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from models.daily_log import DailyLog
from models.running_session import RunningSession
from models.habit_streak import HabitStreak
from services.gemini_service import gemini_service
from loguru import logger


class InsightsService:
    """Service for generating AI-powered health insights"""

    async def get_daily_summary(
        self,
        db: AsyncSession,
        user_id: str,
        target_date: date,
        user_profile: Dict[str, Any],
    ) -> Dict[str, Any]:
        """
        Generate AI-powered daily summary based on user's logs.
        """
        # Fetch daily log
        result = await db.execute(
            select(DailyLog).where(
                DailyLog.user_id == user_id,
                DailyLog.date == target_date
            )
        )
        daily_log = result.scalar_one_or_none()

        if not daily_log:
            return {"message": "No data logged for this date"}

        # Build context for AI
        context = self._build_daily_context(daily_log, user_profile)

        # Load system prompt
        system_prompt = self._load_prompt("daily_summary")

        # Generate AI response
        response = await gemini_service.generate_response(
            prompt=context,
            system_instruction=system_prompt,
            model="flash",
            temperature=0.7,
        )

        return {
            "summary": response["text"],
            "date": target_date.isoformat(),
            "tokens_used": response.get("tokens_used", 0),
        }

    async def get_weekly_insight(
        self,
        db: AsyncSession,
        user_id: str,
        week_start: date,
        user_profile: Dict[str, Any],
    ) -> Dict[str, Any]:
        """
        Generate weekly health insight.
        """
        week_end = week_start + timedelta(days=6)

        # Fetch weekly logs
        result = await db.execute(
            select(DailyLog).where(
                DailyLog.user_id == user_id,
                DailyLog.date >= week_start,
                DailyLog.date <= week_end
            )
        )
        weekly_logs = result.scalars().all()

        if not weekly_logs:
            return {"message": "No data logged for this week"}

        # Build weekly context
        context = self._build_weekly_context(weekly_logs, user_profile)

        # Load system prompt
        system_prompt = self._load_prompt("weekly_insight")

        # Generate AI response
        response = await gemini_service.generate_response(
            prompt=context,
            system_instruction=system_prompt,
            model="pro",
            temperature=0.7,
        )

        return {
            "insight": response["text"],
            "week_start": week_start.isoformat(),
            "week_end": week_end.isoformat(),
            "days_logged": len(weekly_logs),
            "tokens_used": response.get("tokens_used", 0),
        }

    async def get_habit_analysis(
        self,
        db: AsyncSession,
        user_id: str,
        user_profile: Dict[str, Any],
    ) -> Dict[str, Any]:
        """
        Analyze user's habit streaks and provide recommendations.
        """
        # Fetch habit streaks
        result = await db.execute(
            select(HabitStreak).where(HabitStreak.user_id == user_id)
        )
        habits = result.scalars().all()

        if not habits:
            return {"message": "No habits tracked yet. Start by logging your daily activities!"}

        # Build context
        habit_data = [
            {
                "name": h.habit_name,
                "current_streak": h.current_streak,
                "best_streak": h.best_streak,
                "last_completed": h.last_completed.isoformat() if h.last_completed else "Never",
            }
            for h in habits
        ]

        context = f"User Habits: {habit_data}\nUser Profile: {user_profile}"

        # Load system prompt
        system_prompt = self._load_prompt("habit_analysis")

        response = await gemini_service.generate_response(
            prompt=context,
            system_instruction=system_prompt,
            model="pro",
            temperature=0.7,
        )

        return {
            "analysis": response["text"],
            "habits_count": len(habits),
            "tokens_used": response.get("tokens_used", 0),
        }

    def _build_daily_context(self, daily_log: DailyLog, user_profile: Dict) -> str:
        """Build context string for daily summary"""
        return f"""
User Profile:
- Age: {user_profile.get('age', 'N/A')}
- Weight: {user_profile.get('weight_kg', 'N/A')} kg
- Height: {user_profile.get('height_cm', 'N/A')} cm

Daily Log for {daily_log.date}:
- Steps: {daily_log.steps}
- Sleep: {daily_log.sleep_hours or 'N/A'} hours (Quality: {daily_log.sleep_quality or 'N/A'}/10)
- Water: {daily_log.water_ml} ml
- Meals: {daily_log.meals or 'Not logged'}
- Mood: {daily_log.mood or 'Not logged'}
- Calories Consumed: {daily_log.calories_consumed or 'N/A'}
- Calories Burned: {daily_log.calories_burned or 'N/A'}
- Notes: {daily_log.notes or 'None'}
"""

    def _build_weekly_context(self, weekly_logs: List[DailyLog], user_profile: Dict) -> str:
        """Build context string for weekly insight"""
        logs_text = ""
        for log in weekly_logs:
            logs_text += f"""
{log.date}: Steps={log.steps}, Sleep={log.sleep_hours}h, Water={log.water_ml}ml, Mood={log.mood}
"""
        return f"""
User Profile:
- Age: {user_profile.get('age', 'N/A')}
- Weight: {user_profile.get('weight_kg', 'N/A')} kg

Weekly Logs:
{logs_text}
"""

    def _load_prompt(self, prompt_name: str) -> str:
        """Load system prompt from file"""
        try:
            prompt_path = f"prompts/{prompt_name}.md"
            with open(prompt_path, "r") as f:
                return f.read()
        except FileNotFoundError:
            # Return default prompt if file not found
            return self._get_default_prompt(prompt_name)

    def _get_default_prompt(self, prompt_name: str) -> str:
        """Default prompts when files don't exist"""
        prompts = {
            "daily_summary": """You are a friendly health coach analyzing daily health data. 
Provide a brief, encouraging summary of the user's day. Highlight achievements and suggest improvements.
Be positive, motivational, and specific.""",
            
            "weekly_insight": """You are a health analyst reviewing weekly health patterns.
Provide actionable insights based on the week's data. Identify trends, strengths, and areas for improvement.
Include specific recommendations for the upcoming week.""",
            
            "habit_analysis": """You are a habit formation expert analyzing streak data.
Provide encouragement for maintaining streaks and strategies for breaking through plateaus.
Be supportive and give practical advice.""",
        }
        return prompts.get(prompt_name, "You are a helpful health assistant.")


# Singleton instance
insights_service = InsightsService()