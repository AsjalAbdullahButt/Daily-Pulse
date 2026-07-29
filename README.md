# 🏃‍♂️ Daily Pulse

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**Your AI-Powered Health & Wellness Companion**

[![GitHub Stars](https://img.shields.io/github/stars/AsjalAbdullahButt/Daily-Pulse?style=social)](https://github.com/AsjalAbdullahButt/Daily-Pulse)
[![GitHub Forks](https://img.shields.io/github/forks/AsjalAbdullahButt/Daily-Pulse?style=social)](https://github.com/AsjalAbdullahButt/Daily-Pulse)
[![GitHub Issues](https://img.shields.io/github/issues/AsjalAbdullahButt/Daily-Pulse)](https://github.com/AsjalAbdullahButt/Daily-Pulse/issues)

</div>

---

## 📱 About the Project

**Daily Pulse** is a comprehensive health tracking application that combines **mobile technology**, **AI-powered insights**, and **real-time data analysis** to help users build healthier habits and achieve their wellness goals.

Track your daily activities, sleep, nutrition, mood, and workouts — all while receiving personalized AI coaching to optimize your health journey.

---

## ✨ Key Features

### 🏋️ Activity Tracking
- 📊 **Step Counter** — Real-time step tracking via accelerometer sensors
- 🏃 **GPS Running Tracker** — Track distance, pace, speed, and route with GeoJSON
- 🔥 **Calorie Calculator** — Automatic calorie burn estimation

### 😴 Sleep & Recovery
- 🌙 **Sleep Logging** — Track hours slept and sleep quality (1-10)
- 📈 **Sleep Analytics** — Identify patterns and improve rest

### 🥗 Nutrition & Hydration
- 💧 **Water Intake Tracker** — Daily hydration goals based on body weight
- 🍽️ **Meal Logging** — Track meals with calorie estimation

### 🧠 Mental Health
- 😊 **Mood Tracking** — Log daily emotional states
- 🎯 **AI-Powered Insights** — Personalized wellness recommendations

### 🤖 AI Assistant
- 💬 **Chat Interface** — Natural language logging via AI chat
- 📊 **Daily/Weekly Reports** — AI-generated health summaries
- 🎯 **Habit Coaching** — Streak tracking with intelligent suggestions

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        DAILY PULSE                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │  Flutter App  │◄──►│  FastAPI      │◄──►│  MySQL DB    │      │
│  │  (Mobile)    │    │  (Backend)   │    │  (Database)  │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│         │                   │                    │               │
│         │                   │                    │               │
│  ┌──────┴──────┐    ┌──────┴──────┐    ┌──────┴──────┐      │
│  │   Sensors   │    │   Gemini AI │    │   Redis     │      │
│  │   GPS       │    │   (LLM)     │    │   (Cache)   │      │
│  └─────────────┘    └─────────────┘    └─────────────┘      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 📦 Components

| Component | Technology | Description |
|-----------|------------|-------------|
| 📱 **Mobile App** | Flutter + Dart | Native iOS/Android with sensors |
| ⚙️ **Backend API** | FastAPI + Python | REST API + WebSocket |
| 🗄️ **Database** | MySQL | Async SQLAlchemy ORM |
| 🤖 **AI Engine** | Google Gemini | Health insights & chat |
| 🐳 **Deployment** | Docker | Containerized services |

---

## 🛠️ Tech Stack

### 📱 Frontend (Flutter)
- `sensors_plus` — Accelerometer for step counting
- `geolocator` — GPS for running/jogging tracking
- `dio` — HTTP client for API communication
- `provider` / `riverpod` — State management
- `sqflite` — Local database caching

### ⚙️ Backend (FastAPI)
- `fastapi` — Modern async web framework
- `sqlalchemy` — Async ORM for MySQL
- `asyncmy` — Async MySQL driver
- `python-jose` — JWT authentication
- `passlib` — Password hashing (bcrypt)
- `google-generativeai` — Gemini AI integration

### 🗄️ Database (MySQL)
- Users & Authentication
- Daily Health Logs
- Running Sessions
- Chat History
- Habit Streaks
- Heart Rate Logs

---

## 🚀 Getting Started

### 📋 Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0+)
- [Python 3.11+](https://www.python.org/downloads/)
- [MySQL 8.0+](https://dev.mysql.com/downloads/mysql/)
- [Docker](https://docs.docker.com/get-docker/) (optional)

### 🔧 Installation

#### 1️⃣ Clone the Repository

```bash
git clone https://github.com/AsjalAbdullahButt/Daily-Pulse.git
cd Daily-Pulse
```

#### 2️⃣ Backend Setup

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env.example .env
# Edit .env with your database credentials and API keys
```

#### 3️⃣ Database Setup

**Option A: Using Docker (Recommended)**
```bash
cd backend
docker-compose up -d
```

**Option B: Manual MySQL Setup**
```sql
CREATE DATABASE daily_pulse;
CREATE USER 'daily_pulse_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON daily_pulse.* TO 'daily_pulse_user'@'localhost';
```

#### 4️⃣ Start the Backend

```bash
cd backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

API docs available at: `http://localhost:8000/docs`

#### 5️⃣ Flutter App Setup

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

---

## 📁 Project Structure

```
Daily-Pulse/
├── 📱 flutter_app/              # Flutter mobile application
│   ├── lib/
│   │   ├── screens/            # UI screens
│   │   ├── widgets/            # Reusable widgets
│   │   ├── services/           # API services
│   │   ├── models/             # Data models
│   │   └── providers/          # State management
│   └── pubspec.yaml
│
├── ⚙️ backend/                  # FastAPI backend
│   ├── 🗄️ database/            # Database configuration
│   │   └── database.py         # SQLAlchemy async setup
│   ├── 📦 models/              # SQLAlchemy models
│   │   ├── user.py             # User model
│   │   ├── daily_log.py        # Daily health log
│   │   ├── running_session.py  # Running data
│   │   ├── chat_history.py     # Chat messages
│   │   ├── habit_streak.py     # Habit tracking
│   │   └── heart_rate_log.py   # Heart rate data
│   ├── 🎯 routes/              # API endpoints
│   │   ├── auth.py             # Authentication
│   │   ├── logs.py             # Daily logs
│   │   ├── running.py          # Running sessions
│   │   ├── insights.py         # AI insights
│   │   ├── chat.py             # Chat + WebSocket
│   │   └── habits.py           # Habit streaks
│   ├── 🔧 services/            # Business logic
│   │   ├── auth.py             # JWT + password hashing
│   │   ├── gemini_service.py   # AI integration
│   │   ├── insights_service.py # Health analysis
│   │   ├── habit_service.py    # Streak tracking
│   │   └── calculation_service.py # Metrics calculation
│   ├── 📝 schemas/             # Pydantic validation
│   ├── 📝 prompts/             # AI system prompts
│   ├── 🐳 Dockerfile          # Docker config
│   ├── 🐳 docker-compose.yml  # Docker services
│   ├── 📋 requirements.txt    # Python dependencies
│   └── 🚀 main.py             # FastAPI entry point
│
├── 📝 .gitignore
└── 📝 README.md
```

---

## 📚 API Reference

### 🔐 Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/register` | Register new user |
| `POST` | `/api/auth/login` | Login & get tokens |
| `POST` | `/api/auth/refresh` | Refresh access token |
| `GET` | `/api/auth/me` | Get current user |
| `PUT` | `/api/auth/me` | Update profile |

### 📊 Daily Logs

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/logs/daily` | Create/update daily log |
| `GET` | `/api/logs/daily` | Get logs (with date filter) |
| `GET` | `/api/logs/daily/today` | Get today's log |
| `GET` | `/api/logs/daily/{id}` | Get specific log |
| `PUT` | `/api/logs/daily/{id}` | Update log |
| `DELETE` | `/api/logs/daily/{id}` | Delete log |

### 🏃 Running Sessions

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/running/sessions` | Create running session |
| `GET` | `/api/running/sessions` | Get all sessions |
| `GET` | `/api/running/sessions/{id}` | Get specific session |
| `GET` | `/api/running/stats` | Get running statistics |

### 🤖 AI Insights

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/insights/daily-summary` | AI daily summary |
| `GET` | `/api/insights/weekly-insight` | AI weekly analysis |
| `GET` | `/api/insights/habit-analysis` | Habit recommendations |
| `GET` | `/api/insights/health-metrics` | BMI, BMR, TDEE |

### 💬 Chat

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/chat/send` | Send message to AI |
| `GET` | `/api/chat/history` | Get chat history |
| `WS` | `/api/chat/ws/{user_id}` | WebSocket chat |

### 🎯 Habits

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/habits/` | Get all habits |
| `POST` | `/api/habits/` | Create new habit |
| `PUT` | `/api/habits/{id}` | Update habit |
| `DELETE` | `/api/habits/{id}` | Delete habit |
| `POST` | `/api/habits/{id}/complete` | Mark complete |

---

## 🐳 Docker Deployment

```bash
cd backend

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Services Started:
- 🗄️ **MySQL** — Port 3306
- 🔴 **Redis** — Port 6379
- ⚙️ **Backend API** — Port 8000

---

## 🔒 Security

- 🔑 **JWT Authentication** — Secure token-based auth
- 🔒 **Password Hashing** — bcrypt encryption
- 🛡️ **CORS Protection** — Configurable allowed origins
- 🔐 **Environment Variables** — Secrets in `.env` (not in git)
- 🚫 **No Sensitive Data** — `.env`, `__pycache__`, keys excluded via `.gitignore`

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. 🍴 **Fork** the repository
2. 🌿 **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. 💾 **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. 📤 **Push** to the branch (`git push origin feature/amazing-feature`)
5. 📬 **Open** a Pull Request

---

## 📝 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Asjal Abdullah Butt**

- 🐙 GitHub: [@AsjalAbdullahButt](https://github.com/AsjalAbdullahButt)
- 📧 Email: asjal.abdullah.butt@gmail.com

---

## 🙏 Acknowledgments

- 🐦 [Flutter](https://flutter.dev/) — Beautiful cross-platform UI
- ⚡ [FastAPI](https://fastapi.tiangolo.com/) — High-performance Python API
- 🤖 [Google Gemini](https://ai.google.dev/) — AI-powered insights
- 🐬 [MySQL](https://www.mysql.com/) — Reliable database
- 🐳 [Docker](https://www.docker.com/) — Containerization

---

<div align="center">

**Made with ❤️ by Asjal Abdullah Butt**

⭐ Star this repo if you find it helpful!

</div>
