"""
Running Session Routes - CRUD for running/jogging sessions
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from database.database import get_db
from models.user import User
from models.running_session import RunningSession
from schemas.running_session import (
    RunningSessionCreate, RunningSessionResponse, RunningStats,
)
from services.auth import get_current_user
from services.calculation_service import calculation_service
from typing import List, Optional
from datetime import datetime, timedelta

router = APIRouter(prefix="/api/running", tags=["Running Sessions"])


@router.post("/sessions", response_model=RunningSessionResponse, status_code=status.HTTP_201_CREATED)
async def create_running_session(
    session_data: RunningSessionCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Create a new running session.
    """
    # Calculate calories if not provided
    calories = session_data.calories_burned
    if not calories and current_user.weight_kg:
        calories = calculation_service.calculate_running_calories(
            distance_km=session_data.distance_km,
            duration_seconds=session_data.duration_seconds,
            weight_kg=current_user.weight_kg,
        )
    
    # Calculate pace and speed if not provided
    avg_pace = session_data.avg_pace
    max_speed = session_data.max_speed
    
    if not avg_pace:
        avg_pace = calculation_service.calculate_pace(
            distance_km=session_data.distance_km,
            duration_seconds=session_data.duration_seconds,
        )
    
    if not max_speed:
        max_speed = calculation_service.calculate_speed(
            distance_km=session_data.distance_km,
            duration_seconds=session_data.duration_seconds,
        )
    
    running_session = RunningSession(
        user_id=current_user.id,
        date=session_data.date,
        distance_km=session_data.distance_km,
        duration_seconds=session_data.duration_seconds,
        avg_pace=avg_pace,
        max_speed=max_speed,
        route_geojson=session_data.route_geojson,
        calories_burned=calories,
        elevation_gain=session_data.elevation_gain,
        avg_heart_rate=session_data.avg_heart_rate,
        notes=session_data.notes,
    )
    db.add(running_session)
    await db.flush()
    
    return RunningSessionResponse.model_validate(running_session)


@router.get("/sessions", response_model=List[RunningSessionResponse])
async def get_running_sessions(
    start_date: Optional[datetime] = Query(None),
    end_date: Optional[datetime] = Query(None),
    limit: int = Query(50, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get running sessions for current user.
    """
    query = select(RunningSession).where(RunningSession.user_id == current_user.id)
    
    if start_date:
        query = query.where(RunningSession.date >= start_date)
    if end_date:
        query = query.where(RunningSession.date <= end_date)
    
    query = query.order_by(RunningSession.date.desc()).limit(limit)
    
    result = await db.execute(query)
    sessions = result.scalars().all()
    
    return [RunningSessionResponse.model_validate(s) for s in sessions]


@router.get("/sessions/{session_id}", response_model=RunningSessionResponse)
async def get_running_session(
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get a specific running session by ID.
    """
    result = await db.execute(
        select(RunningSession).where(
            and_(
                RunningSession.id == session_id,
                RunningSession.user_id == current_user.id,
            )
        )
    )
    session = result.scalar_one_or_none()
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Running session not found"
        )
    
    return RunningSessionResponse.model_validate(session)


@router.delete("/sessions/{session_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_running_session(
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Delete a running session.
    """
    result = await db.execute(
        select(RunningSession).where(
            and_(
                RunningSession.id == session_id,
                RunningSession.user_id == current_user.id,
            )
        )
    )
    session = result.scalar_one_or_none()
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Running session not found"
        )
    
    await db.delete(session)


@router.get("/stats", response_model=RunningStats)
async def get_running_stats(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get running statistics for current user.
    """
    result = await db.execute(
        select(RunningSession).where(RunningSession.user_id == current_user.id)
    )
    sessions = result.scalars().all()
    
    if not sessions:
        return RunningStats(
            total_distance_km=0,
            total_sessions=0,
            avg_distance=0,
            best_distance=0,
            total_duration_seconds=0,
            avg_pace=None,
        )
    
    total_distance = sum(s.distance_km for s in sessions)
    total_duration = sum(s.duration_seconds for s in sessions)
    avg_pace = calculation_service.calculate_pace(total_distance, total_duration) if total_duration > 0 else None
    
    return RunningStats(
        total_distance_km=round(total_distance, 2),
        total_sessions=len(sessions),
        avg_distance=round(total_distance / len(sessions), 2),
        best_distance=max(s.distance_km for s in sessions),
        total_duration_seconds=total_duration,
        avg_pace=avg_pace,
    )