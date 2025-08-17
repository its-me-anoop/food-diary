"""Route definitions for the Food Diary application."""
from datetime import datetime
from flask import Blueprint, current_app, redirect, render_template, request, url_for
from .models import FoodEntry

bp = Blueprint('main', __name__)


@bp.route('/')
def index():
    """Render the home page listing all food entries."""
    entries = current_app.config['ENTRIES']
    return render_template('index.html', entries=entries)


@bp.route('/add', methods=['GET', 'POST'])
def add_entry():
    """Handle adding a new food entry."""
    if request.method == 'POST':
        food = request.form['food']
        calories = int(request.form['calories'])
        entry = FoodEntry(food=food, calories=calories, timestamp=datetime.utcnow())
        current_app.config['ENTRIES'].append(entry)
        return redirect(url_for('main.index'))
    return render_template('add_entry.html')
