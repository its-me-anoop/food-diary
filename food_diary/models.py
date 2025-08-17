"""Data models for Food Diary."""
from dataclasses import dataclass
from datetime import datetime


@dataclass
class FoodEntry:
    """Represents a food entry recorded by the user."""
    food: str
    calories: int
    timestamp: datetime
