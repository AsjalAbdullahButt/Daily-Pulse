"""
Daily Pulse Backend - FastAPI Application
"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from database.database import init_db, check_db_connection
from routes import (
    auth_router,
    logs_router,
    insights_router,
    chat_router,
    habits_router,
    running_router,
)
import os
from dotenv import load_dotenv
from loguru import logger

load_dotenv()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifespan events - startup and shutdown.
    """
    # Startup
    logger.info("Starting Daily Pulse Backend...")
    
    # Initialize database
    try:
        await init_db()
        logger.info("Database tables created successfully")
    except Exception as e:
        logger.error(f"Failed to initialize database: {e}")
        raise
    
    # Check database connection
    db_healthy = await check_db_connection()
    if db_healthy:
        logger.info("Database connection healthy")
    else:
        logger.warning("Database connection failed - running without database")
    
    yield
    
    # Shutdown
    logger.info("Shutting down Daily Pulse Backend...")


# Create FastAPI app
app = FastAPI(
    title="Daily Pulse API",
    description="Backend API for Daily Pulse health tracking app",
    version="1.0.0",
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=os.getenv("ALLOWED_ORIGINS", "http://localhost:3000,http://localhost:8080").split(","),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth_router)
app.include_router(logs_router)
app.include_router(insights_router)
app.include_router(chat_router)
app.include_router(habits_router)
app.include_router(running_router)


@app.get("/")
async def root():
    """Root endpoint - API info"""
    return {
        "name": "Daily Pulse API",
        "version": "1.0.0",
        "docs": "/docs",
        "status": "running",
    }


@app.get("/health")
async def health_check():
    """
    Health check endpoint.
    """
    db_healthy = await check_db_connection()
    return {
        "status": "healthy" if db_healthy else "degraded",
        "database": "connected" if db_healthy else "disconnected",
        "version": "1.0.0",
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host=os.getenv("HOST", "0.0.0.0"),
        port=int(os.getenv("PORT", "8000")),
        reload=os.getenv("DEBUG", "true").lower() == "true",
    )