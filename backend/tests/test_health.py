"""
Health endpoint tests
"""
import pytest


@pytest.mark.asyncio
async def test_root(client):
    res = await client.get("/")
    assert res.status_code == 200
    data = res.json()
    assert data["name"] == "Daily Pulse API"
    assert data["status"] == "running"


@pytest.mark.asyncio
async def test_health(client):
    res = await client.get("/health")
    assert res.status_code == 200
    assert "status" in res.json()
    assert "version" in res.json()
