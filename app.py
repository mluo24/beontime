import json

from flask import Flask
from db import db, Course, Assignment, User

app = Flask(__name__)

db_filename = "beontime.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


# generalized response formats
def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}), code


def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code


# course endpoints
@app.route('/api/courses/')
def get_courses():
    courses = [c.serialize() for c in Course.query.all()]
    return success_response(courses)


# assignment endpoints
@app.route('/api/assignments/')
def get_assignments():
    assignments = [a.serialize() for a in Assignment.query.all()]
    return success_response(assignments)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
