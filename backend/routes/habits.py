"""
Habit Streak Routes - Manage and track habits
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from database.database import get_db
from models.user import User
from schemas.chat import HabitStreakCreate, HabitStreakUpdate, HabitStreakResponse
from services.auth import get_current_user
from services.habit_service import habit_service
from typing import List

router = APIRouter(prefix="/api/habits", tags=["Habit Streaks"])


@router.get("/", response_model=List[HabitStreakResponse])
async def get_habits(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Get all habits for current user.
    """
    habits = await habit_service.get_user_habits(db, current_user.id)
    return [HabitStreakResponse.model_validate(h) for h in habits]


@router.post("/", response_model=HabitStreakResponse, status_code=status.HTTP_201_CREATED)
async def create_habit(
    habit_data: HabitStreakCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Create a new habit to track.
    """
    habit = await habit_service.create_habit(
        db=db,
        user_id=current_user.id,
        habit_name=habit_data.habit_name,
        target_frequency=habit_data.target_frequency,
    )
    return HabitStreakResponse.model_validate(habit)


@router.put("/{habit_id}", response_model=HabitStreakResponse)
async def update_habit(
    habit_id: str,
    habit_update: HabitStreakUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Update a habit's details.
    """
    habit = await habit_service.update_habit(
        db=db,
        habit_id=habit_id,
        user_id=current_user.id,
        habit_name=habit_update.habit_name,
        target_frequency=habit_update.target_frequency,
    )
    
    if not habit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Habit not found"
        )
    
    return HabitStreakResponse.model_validate(habit)


@router.delete("/{habit_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_habit(
    habit_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Delete a habit.
    """
    success = await habit_service.delete_habit(db, habit_id, current_user.id)
    
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Habit not found"
        )


@router.post("/{habit_id}/complete", response_model=HabitStreakResponse)
async def mark_habit_complete(
    habit_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    Mark a habit as completed for today.
    """
    habit = await habit_service.mark_habit_complete(
        db=db,
        habit_id=habit_id,
        user_id=current_user.id,
    )
    
    if not habit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Habit not found"
        )
    
    return HabitStreakResponse.model_validate(habit)