"""
Insights Routes - AI-powered health insights
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from database.database import get_db
from models.user import User
from services.auth import get_current_user
from services.insights_service import insights_service
from datetime import date, timedelta

router = APIRouter(prefix="/api/insights", tags=["AI Insights"])


@router.get("/daily-summary")
async def get_daily_summary(
    target_date: date = Query(default=None, description="Date for summary"),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get AI-powered daily health summary.
    """
    if not target_date:
        target_date = date.today()
    
    user_profile = {
        "age": current_user.age,
        "weight_kg": current_user.weight_kg,
        "height_cm": current_user.height_cm,
    }
    
    summary = await insights_service.get_daily_summary(
        db=db,
        user_id=current_user.id,
        target_date=target_date,
        user_profile=user_profile,
    )
    
    return summary


@router.get("/weekly-insight")
async def get_weekly_insight(
    week_start: date = Query(default=None, description="Start of week (Monday)"),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get AI-powered weekly health insight.
    """
    if not week_start:
        today = date.today()
        week_start = today - timedelta(days=today.weekday())
    
    user_profile = {
        "age": current_user.age,
        "weight_kg": current_user.weight_kg,
        "height_cm": current_user.height_cm,
    }
    
    insight = await insights_service.get_weekly_insight(
        db=db,
        user_id=current_user.id,
        week_start=week_start,
        user_profile=user_profile,
    )
    
    return insight


@router.get("/habit-analysis")
async def get_habit_analysis(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get AI-powered habit analysis and recommendations.
    """
    user_profile = {
        "age": current_user.age,
        "weight_kg": current_user.weight_kg,
        "height_cm": current_user.height_cm,
    }
    
    analysis = await insights_service.get_habit_analysis(
        db=db,
        user_id=current_user.id,
        user_profile=user_profile,
    )
    
    return analysis


@router.get("/health-metrics")
async def get_health_metrics(
    current_user: User = Depends(get_current_user),
):
    """
    Calculate health metrics (BMI, BMR, TDEE).
    """
    from services.calculation_service import calculation_service
    
    if not current_user.weight_kg or not current_user.height_cm or not current_user.age:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Please complete your profile (weight, height, age) to calculate health metrics"
        )
    
    bmi = calculation_service.calculate_bmi(
        weight_kg=current_user.weight_kg,
        height_cm=current_user.height_cm,
    )
    
    bmr = calculation_service.calculate_bmr(
        weight_kg=current_user.weight_kg,
        height_cm=current_user.height_cm,
        age=current_user.age,
    )
    
    tdee = calculation_service.calculate_tdee(bmr)
    
    return {
        "bmi": bmi,
        "bmr": round(bmr, 0),
        "tdee": round(tdee, 0),
        "recommended_water_ml": int(current_user.weight_kg * 33),  # ~33ml per kg
    }