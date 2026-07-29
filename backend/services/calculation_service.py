"""
Calculation Service - Health metrics and calculations
"""
from typing import Optional, Dict, Any
from datetime import date, timedelta
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from models.daily_log import DailyLog
from models.running_session import RunningSession


class CalculationService:
    """Service for calculating health metrics"""

    # Activity level multipliers for calorie calculation
    ACTIVITY_MULTIPLIERS = {
        "sedentary": 1.2,
        "light": 1.375,
        "moderate": 1.55,
        "active": 1.725,
        "very_active": 1.9,
    }

    # MET values for running speed ranges
    RUNNING_METS = {
        (0, 6): 6.0,      # Walking/jogging < 6 km/h
        (6, 8): 8.3,      # Running 6-8 km/h
        (8, 10): 9.8,     # Running 8-10 km/h
        (10, 12): 11.0,   # Running 10-12 km/h
        (12, 14): 11.8,   # Running 12-14 km/h
        (14, 16): 12.8,   # Running 14-16 km/h
        (16, 20): 14.5,   # Fast running 16-20 km/h
    }

    def calculate_bmr(self, weight_kg: float, height_cm: float, age: int, gender: str = "male") -> float:
        """
        Calculate Basal Metabolic Rate using Mifflin-St Jeor equation.
        """
        if gender.lower() == "male":
            bmr = 10 * weight_kg + 6.25 * height_cm - 5 * age + 5
        else:
            bmr = 10 * weight_kg + 6.25 * height_cm - 5 * age - 161
        return bmr

    def calculate_tdee(self, bmr: float, activity_level: str = "moderate") -> float:
        """
        Calculate Total Daily Energy Expenditure.
        """
        multiplier = self.ACTIVITY_MULTIPLIERS.get(activity_level, 1.55)
        return bmr * multiplier

    def calculate_bmi(self, weight_kg: float, height_cm: float) -> Dict[str, Any]:
        """
        Calculate BMI and provide category.
        """
        height_m = height_cm / 100
        bmi = weight_kg / (height_m ** 2)
        
        if bmi < 18.5:
            category = "Underweight"
        elif bmi < 25:
            category = "Normal weight"
        elif bmi < 30:
            category = "Overweight"
        else:
            category = "Obese"
        
        return {
            "bmi": round(bmi, 1),
            "category": category,
            "healthy_range": "18.5 - 24.9",
        }

    def calculate_calories_from_steps(
        self,
        steps: int,
        weight_kg: float = 70.0,
        height_cm: float = 170.0,
    ) -> int:
        """
        Calculate calories burned from steps.
        Average stride length and MET calculation.
        """
        # Average stride length in meters
        stride_length = height_cm * 0.415 / 100  # ~41.5% of height
        
        # Distance in km
        distance_km = (steps * stride_length) / 1000
        
        # Estimated duration in hours (average walking speed ~5 km/h)
        duration_hours = distance_km / 5.0 if distance_km > 0 else 0
        
        # Calories = MET × weight(kg) × time(hours)
        # Walking MET ≈ 3.5
        calories = 3.5 * weight_kg * duration_hours
        
        return max(0, int(calories))

    def calculate_running_calories(
        self,
        distance_km: float,
        duration_seconds: int,
        weight_kg: float = 70.0,
    ) -> int:
        """
        Calculate calories burned during running.
        """
        duration_hours = duration_seconds / 3600
        speed_kmh = distance_km / duration_hours if duration_hours > 0 else 0
        
        # Find MET value based on speed
        met = 8.3  # Default
        for speed_range, met_value in self.RUNNING_METS.items():
            if speed_range[0] <= speed_kmh < speed_range[1]:
                met = met_value
                break
        
        calories = met * weight_kg * duration_hours
        return max(0, int(calories))

    def calculate_pace(self, distance_km: float, duration_seconds: int) -> Optional[float]:
        """
        Calculate average pace in minutes per kilometer.
        """
        if distance_km <= 0 or duration_seconds <= 0:
            return None
        
        pace_seconds = duration_seconds / distance_km
        pace_minutes = pace_seconds / 60
        return round(pace_minutes, 2)

    def calculate_speed(self, distance_km: float, duration_seconds: int) -> Optional[float]:
        """
        Calculate average speed in km/h.
        """
        if duration_seconds <= 0:
            return None
        
        duration_hours = duration_seconds / 3600
        speed = distance_km / duration_hours
        return round(speed, 2)

    async def get_weekly_stats(
        self,
        db: AsyncSession,
        user_id: str,
        week_start: date,
    ) -> Dict[str, Any]:
        """
        Calculate weekly statistics from daily logs.
        """
        week_end = week_start + timedelta(days=6)
        
        result = await db.execute(
            select(DailyLog).where(
                DailyLog.user_id == user_id,
                DailyLog.date >= week_start,
                DailyLog.date <= week_end
            )
        )
        logs = result.scalars().all()
        
        if not logs:
            return {
                "total_steps": 0,
                "avg_steps": 0,
                "total_water_ml": 0,
                "avg_sleep_hours": 0,
                "days_logged": 0,
                "mood_distribution": {},
            }
        
        total_steps = sum(log.steps or 0 for log in logs)
        total_water = sum(log.water_ml or 0 for log in logs)
        sleep_hours = [log.sleep_hours for log in logs if log.sleep_hours is not None]
        moods = [log.mood for log in logs if log.mood]
        
        return {
            "total_steps": total_steps,
            "avg_steps": total_steps // len(logs) if logs else 0,
            "total_water_ml": total_water,
            "avg_water_ml": total_water // len(logs) if logs else 0,
            "avg_sleep_hours": round(sum(sleep_hours) / len(sleep_hours), 1) if sleep_hours else 0,
            "days_logged": len(logs),
            "mood_distribution": {mood: moods.count(mood) for mood in set(moods)} if moods else {},
        }

    async def get_monthly_stats(
        self,
        db: AsyncSession,
        user_id: str,
        year: int,
        month: int,
    ) -> Dict[str, Any]:
        """
        Calculate monthly statistics.
        """
        # Calculate month boundaries
        from datetime import datetime
        month_start = date(year, month, 1)
        if month == 12:
            month_end = date(year + 1, 1, 1) - timedelta(days=1)
        else:
            month_end = date(year, month + 1, 1) - timedelta(days=1)
        
        result = await db.execute(
            select(DailyLog).where(
                DailyLog.user_id == user_id,
                DailyLog.date >= month_start,
                DailyLog.date <= month_end
            )
        )
        logs = result.scalars().all()
        
        # Calculate weekly breakdown
        weekly_totals = []
        current_week_start = month_start
        while current_week_start <= month_end:
            current_week_end = min(current_week_start + timedelta(days=6), month_end)
            week_logs = [
                log for log in logs 
                if current_week_start <= log.date <= current_week_end
            ]
            if week_logs:
                weekly_totals.append({
                    "week_start": current_week_start.isoformat(),
                    "total_steps": sum(log.steps or 0 for log in week_logs),
                    "days_logged": len(week_logs),
                })
            current_week_start += timedelta(days=7)
        
        total_steps = sum(log.steps or 0 for log in logs)
        
        return {
            "total_steps": total_steps,
            "avg_steps_per_day": total_steps // len(logs) if logs else 0,
            "days_logged": len(logs),
            "weekly_breakdown": weekly_totals,
        }


# Singleton instance
calculation_service = CalculationService()