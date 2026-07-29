"""
Daily Logs Routes - CRUD for daily health logs
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_
from database.database import get_db
from models.user import User
from models.daily_log import DailyLog
from models.habit_streak import HabitStreak
from schemas.daily_log import (
    DailyLogCreate, DailyLogUpdate, DailyLogResponse,
    DailyLogDateRange,
)
from services.auth import get_current_user
from services.habit_service import habit_service
from datetime import date, timedelta
from typing import List, Optional

router = APIRouter(prefix="/api/logs", tags=["Daily Logs"])


@router.post("/daily", response_model=DailyLogResponse, status_code=status.HTTP_201_CREATED)
async def create_daily_log(
    log_data: DailyLogCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Create or update a daily log for a specific date.
    """
    # Check if log already exists for this date
    result = await db.execute(
        select(DailyLog).where(
            and_(
                DailyLog.user_id == current_user.id,
                DailyLog.date == log_data.date,
            )
        )
    )
    existing_log = result.scalar_one_or_none()
    
    if existing_log:
        # Update existing log
        update_data = log_data.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(existing_log, key, value)
        await db.flush()
        
        # Auto-check habits
        await habit_service.check_habits_from_daily_log(db, current_user.id, existing_log)
        
        return DailyLogResponse.model_validate(existing_log)
    else:
        # Create new log
        daily_log = DailyLog(
            user_id=current_user.id,
            **log_data.model_dump()
        )
        db.add(daily_log)
        await db.flush()
        
        # Auto-check habits
        await habit_service.check_habits_from_daily_log(db, current_user.id, daily_log)
        
        return DailyLogResponse.model_validate(daily_log)


@router.get("/daily", response_model=List[DailyLogResponse])
async def get_daily_logs(
    date: Optional[date] = Query(None, description="Specific date"),
    start_date: Optional[date] = Query(None, description="Start date for range"),
    end_date: Optional[date] = Query(None, description="End date for range"),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get daily logs for current user.
    Can filter by specific date or date range.
    """
    query = select(DailyLog).where(DailyLog.user_id == current_user.id)
    
    if date:
        query = query.where(DailyLog.date == date)
    elif start_date and end_date:
        query = query.where(
            and_(DailyLog.date >= start_date, DailyLog.date <= end_date)
        )
    
    query = query.order_by(DailyLog.date.desc())
    
    result = await db.execute(query)
    logs = result.scalars().all()
    
    return [DailyLogResponse.model_validate(log) for log in logs]


@router.get("/daily/today", response_model=Optional[DailyLogResponse])
async def get_today_log(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get today's daily log.
    """
    today = date.today()
    result = await db.execute(
        select(DailyLog).where(
            and_(
                DailyLog.user_id == current_user.id,
                DailyLog.date == today,
            )
        )
    )
    log = result.scalar_one_or_none()
    
    if not log:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No log found for today"
        )
    
    return DailyLogResponse.model_validate(log)


@router.get("/daily/{log_id}", response_model=DailyLogResponse)
async def get_daily_log(
    log_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get a specific daily log by ID.
    """
    result = await db.execute(
        select(DailyLog).where(
            and_(
                DailyLog.id == log_id,
                DailyLog.user_id == current_user.id,
            )
        )
    )
    log = result.scalar_one_or_none()
    
    if not log:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Log not found"
        )
    
    return DailyLogResponse.model_validate(log)


@router.put("/daily/{log_id}", response_model=DailyLogResponse)
async def update_daily_log(
    log_id: str,
    log_update: DailyLogUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Update a daily log.
    """
    result = await db.execute(
        select(DailyLog).where(
            and_(
                DailyLog.id == log_id,
                DailyLog.user_id == current_user.id,
            )
        )
    )
    log = result.scalar_one_or_none()
    
    if not log:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Log not found"
        )
    
    update_data = log_update.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(log, key, value)
    
    await db.flush()
    
    # Auto-check habits
    await habit_service.check_habits_from_daily_log(db, current_user.id, log)
    
    return DailyLogResponse.model_validate(log)


@router.delete("/daily/{log_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_daily_log(
    log_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Delete a daily log.
    """
    result = await db.execute(
        select(DailyLog).where(
            and_(
                DailyLog.id == log_id,
                DailyLog.user_id == current_user.id,
            )
        )
    )
    log = result.scalar_one_or_none()
    
    if not log:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Log not found"
        )
    
    await db.delete(log)


@router.get("/stats/weekly", response_model=dict)
async def get_weekly_stats(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get weekly statistics for current user.
    """
    from services.calculation_service import calculation_service
    
    today = date.today()
    week_start = today - timedelta(days=today.weekday())
    
    stats = await calculation_service.get_weekly_stats(
        db=db,
        user_id=current_user.id,
        week_start=week_start,
    )
    
    return stats