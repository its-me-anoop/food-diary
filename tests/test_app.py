"""Tests for the Food Diary Flask application."""
import sys
from pathlib import Path
import pytest

# Ensure the package is on the Python path when running tests directly
sys.path.append(str(Path(__file__).resolve().parents[1]))

from food_diary import create_app


@pytest.fixture
def client():
    app = create_app()
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_index_empty(client):
    """Index page should display message when no entries exist."""
    response = client.get('/')
    assert b'No entries yet.' in response.data


def test_add_entry(client):
    """Adding an entry should store it and display on index."""
    response = client.post('/add', data={'food': 'Apple', 'calories': '95'}, follow_redirects=True)
    assert response.status_code == 200
    assert b'Apple - 95 cal' in response.data
