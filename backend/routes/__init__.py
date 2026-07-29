# Routes package
from routes.auth import router as auth_router
from routes.logs import router as logs_router
from routes.insights import router as insights_router
from routes.chat import router as chat_router
from routes.habits import router as habits_router
from routes.running import router as running_router
from routes.heart_rate import router as heart_rate_router

__all__ = [
    "auth_router",
    "logs_router",
    "insights_router",
    "chat_router",
    "habits_router",
    "running_router",
    "heart_rate_router",
]
