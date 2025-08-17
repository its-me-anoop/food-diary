"""Application factory for Food Diary Flask app."""
from flask import Flask


def create_app() -> Flask:
    """Create and configure the Flask application."""
    app = Flask(__name__)
    app.config['ENTRIES'] = []

    from .routes import bp as main_bp
    app.register_blueprint(main_bp)
    return app
