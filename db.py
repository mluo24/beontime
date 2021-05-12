import requests
from flask_sqlalchemy import SQLAlchemy
import bcrypt
import datetime
import hashlib
import arrow
import os

db = SQLAlchemy()


# models for courses
class Course(db.Model):
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key=True)
    subject = db.Column(db.String, nullable=True)
    code = db.Column(db.Integer, nullable=True)
    name = db.Column(db.String, nullable=False)
    days_on = db.Column(db.String, nullable=True)
    time = db.Column(db.Time, nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    assignments = db.relationship("Assignment", cascade="delete", order_by="asc(Assignment.due_date)")

    def __init__(self, **kwargs):
        self.subject = kwargs.get("subject")
        self.code = kwargs.get("code")
        self.name = kwargs.get("name")
        self.days_on = kwargs.get("days_on")
        self.time = kwargs.get("time")
        self.user_id = kwargs.get("user_id")

    def serialize(self):
        return {
            "id": self.id,
            "subject": self.subject,
            "code": self.code,
            "name": self.name,
            "days_on": self.days_on,
            # "time": datetime.datetime.strftime(self.time, "%-I:%M%p")
            "time":  arrow.get(datetime.datetime.strptime(self.time.isoformat(timespec="auto"), "%H:%M:%S")).format("h:mmA"),
            # num assignments
            "num_assignments": len([a for a in self.assignments if a.type == "assignment"]),
            # num quizzes
            "num_quizzes": len([a for a in self.assignments if a.type == "quiz"]),
            # num tests
            "num_exams": len([a for a in self.assignments if a.type == "exam"]),
            # num projects
            "num_projects": len([a for a in self.assignments if a.type == "project"])
        }


# models for assignments
class Assignment(db.Model):
    __tablename__ = "assignments"
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    due_date = db.Column(db.DateTime, nullable=False)
    description = db.Column(db.String, nullable=True)
    priority = db.Column(db.String, nullable=True)
    type = db.Column(db.String, nullable=False)
    done = db.Column(db.Boolean, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)

    def serialize_without_course(self):
        return {
            "id": self.id,
            "title": self.title,
            "due_date": arrow.get(self.due_date, "America/New_York").format("MMM D, YYYY"),
            "relative_due_date": arrow.get(self.due_date, "America/New_York").humanize(),
            "description": self.description,
            "priority": self.priority,
            "type": self.type,
            "done": self.done
        }

    def serialize(self):
        data = self.serialize_without_course()
        course = Course.query.filter_by(id=self.course_id).first()
        data["course"] = {
            "id": course.id,
            "subject": course.subject,
            "code": course.code,
            "name": course.name
        }
        return data


# model for users
class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=True)
    netid = db.Column(db.String, nullable=True)
    courses = db.relationship("Course", cascade="delete")
    assignments = db.relationship("Assignment", cascade="delete", order_by="asc(Assignment.due_date)")
    
    email = db.Column(db.String, nullable=False, unique=True)
    password_digest = db.Column(db.String, nullable=False)
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs):
        self.email = kwargs.get("email")
        self.password_digest = bcrypt.hashpw(kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13))
        self.renew_session()
        self.name = kwargs.get("name")
        self.netid = kwargs.get("netid")
       
    def _urlsafe_base_64(self):
        return hashlib.sha1(os.urandom(64)).hexdigest()
    
    def renew_session(self):
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1000)
        self.update_token = self._urlsafe_base_64()
     
    def verify_password(self, password):
        return bcrypt.checkpw(password.encode("utf8"),self.password_digest)
    
    def verify_session_token(self, session_token):
        return session_token == self.session_token and datetime.datetime.now() < self.session_expiration
    
    def verify_update_token(self, update_token):
        return update_token == self.update_token
       
    def serialize_without_courses(self):
        return {
            "id": self.id,
            "name": self.name,
            "netid": self.netid
        }

    def serialize(self):
        data = self.serialize_without_courses()
        data["courses"] = [s.serialize() for s in self.courses]
        return data
