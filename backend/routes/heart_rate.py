"""
Heart Rate Log Routes - CRUD for heart rate data
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from database.database import get_db
from models.user import User
from models.heart_rate_log import HeartRateLog
from schemas.heart_rate_log import HeartRateLogCreate, HeartRateLogResponse
from services.auth import get_current_user
from typing import List, Optional
from datetime import datetime, timedelta

router = APIRouter(prefix="/api/heart-rate", tags=["Heart Rate Logs"])


@router.post("/", response_model=HeartRateLogResponse, status_code=status.HTTP_201_CREATED)
async def log_heart_rate(
    log_data: HeartRateLogCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Log a new heart rate reading."""
    hr_log = HeartRateLog(
        user_id=current_user.id,
        timestamp=log_data.timestamp,
        bpm=log_data.bpm,
        source=log_data.source,
        activity=log_data.activity,
    )
    db.add(hr_log)
    await db.flush()
    return HeartRateLogResponse.model_validate(hr_log)


@router.get("/", response_model=List[HeartRateLogResponse])
async def get_heart_rate_logs(
    start_date: Optional[datetime] = Query(None),
    end_date: Optional[datetime] = Query(None),
    limit: int = Query(100, ge=1, le=500),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Get heart rate logs for current user."""
    query = select(HeartRateLog).where(HeartRateLog.user_id == current_user.id)

    if start_date:
        query = query.where(HeartRateLog.timestamp >= start_date)
    if end_date:
        query = query.where(HeartRateLog.timestamp <= end_date)

    query = query.order_by(HeartRateLog.timestamp.desc()).limit(limit)

    result = await db.execute(query)
    logs = result.scalars().all()
    return [HeartRateLogResponse.model_validate(log) for log in logs]


@router.get("/stats")
async def get_heart_rate_stats(
    days: int = Query(7, ge=1, le=90),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Get heart rate statistics over a period."""
    since = datetime.utcnow() - timedelta(days=days)

    result = await db.execute(
        select(HeartRateLog).where(
            and_(
                HeartRateLog.user_id == current_user.id,
                HeartRateLog.timestamp >= since,
            )
        )
    )
    logs = result.scalars().all()

    if not logs:
        return {
            "avg_bpm": 0,
            "min_bpm": 0,
            "max_bpm": 0,
            "readings_count": 0,
            "resting_avg": 0,
        }

    bpms = [log.bpm for log in logs]
    resting = [log.bpm for log in logs if log.activity == "resting"]

    return {
        "avg_bpm": round(sum(bpms) / len(bpms)),
        "min_bpm": min(bpms),
        "max_bpm": max(bpms),
        "readings_count": len(bpms),
        "resting_avg": round(sum(resting) / len(resting)) if resting else 0,
    }


@router.delete("/{log_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_heart_rate_log(
    log_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Delete a heart rate log entry."""
    result = await db.execute(
        select(HeartRateLog).where(
            and_(
                HeartRateLog.id == log_id,
                HeartRateLog.user_id == current_user.id,
            )
        )
    )
    log = result.scalar_one_or_none()

    if not log:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Heart rate log not found"
        )

    await db.delete(log)
