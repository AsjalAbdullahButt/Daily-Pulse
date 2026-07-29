"""
Authentication route tests
"""
import pytest

TEST_USER = {
    "email": "test@example.com",
    "password": "securepass123",
    "name": "Test User",
}


@pytest.mark.asyncio
async def test_register_user(client):
    res = await client.post("/api/auth/register", json=TEST_USER)
    assert res.status_code == 201
    data = res.json()
    assert "access_token" in data
    assert data["user"]["email"] == TEST_USER["email"]


@pytest.mark.asyncio
async def test_register_duplicate_email(client):
    await client.post("/api/auth/register", json=TEST_USER)
    res = await client.post("/api/auth/register", json=TEST_USER)
    assert res.status_code == 400


@pytest.mark.asyncio
async def test_login_user(client):
    await client.post("/api/auth/register", json=TEST_USER)
    res = await client.post("/api/auth/login", json={
        "email": TEST_USER["email"],
        "password": TEST_USER["password"],
    })
    assert res.status_code == 200
    assert "access_token" in res.json()


@pytest.mark.asyncio
async def test_login_wrong_password(client):
    await client.post("/api/auth/register", json=TEST_USER)
    res = await client.post("/api/auth/login", json={
        "email": TEST_USER["email"],
        "password": "wrongpassword",
    })
    assert res.status_code == 401


@pytest.mark.asyncio
async def test_get_me(client):
    reg = await client.post("/api/auth/register", json=TEST_USER)
    token = reg.json()["access_token"]
    res = await client.get("/api/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert res.status_code == 200
    assert res.json()["email"] == TEST_USER["email"]


@pytest.mark.asyncio
async def test_get_me_unauthorized(client):
    res = await client.get("/api/auth/me")
    assert res.status_code == 403
