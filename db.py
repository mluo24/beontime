from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


# EVERYTHING BELOW IS COPIED DIRECTLY FROM PA4. PLEASE EDIT IT TO BE THE CORRECT FORM
# I commented out what I think we don't need, I only kept it so things can compile/make sense

# class Association(db.Model):
#     __tablename__ = "association"
#     __table_args__ = (
#         db.PrimaryKeyConstraint('course_id', 'user_id'),
#     )
#     course_id = db.Column(db.Integer, db.ForeignKey("courses.id"))
#     user_id = db.Column(db.Integer, db.ForeignKey("users.id"))
#     role = db.Column(db.String, nullable=False)
#     course = db.relationship("Course", back_populates="users")
#     user = db.relationship("User", back_populates="courses")
#
#     def __init__(self, **kwargs):
#         self.role = kwargs.get("role")


# models for courses
class Course(db.Model):
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)
    assignments = db.relationship("Assignment", cascade="delete")
    # users = db.relationship("Association", back_populates="course")

    def __init__(self, **kwargs):
        self.code = kwargs.get("code")
        self.name = kwargs.get("name")

    def serialize(self):
        return {
            "id": self.id,
            "code": self.code,
            "name": self.name,
            "assignments": [s.serialize_without_course() for s in self.assignments],
            # "instructors": [s.user.serialize_without_courses() for s in self.users if s.user.get_role_in_course(self.id)
            #                 == "instructor"],
            # "students": [s.user.serialize_without_courses() for s in self.users if s.user.get_role_in_course(self.id)
            #              == "student"]
        }


# models for assignments
class Assignment(db.Model):
    __tablename__ = "assignments"
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    due_date = db.Column(db.Integer)
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable=False)

    def serialize_without_course(self):
        return {
            "id": self.id,
            "title": self.title,
            "due_date": self.due_date
        }

    def serialize(self):
        data = self.serialize_without_course()
        course = Course.query.filter_by(id=self.course_id).first()
        data["course"] = {
            "id": course.id,
            "code": course.code,
            "name": course.name
        }
        return data


# model for users
class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    courses = db.relationship("Association", back_populates="user")

    # def get_role_in_course(self, course_id):
    #     row = Association.query.filter_by(course_id=course_id, user_id=self.id).first()
    #     return row.role

    def serialize_without_courses(self):
        return {
            "id": self.id,
            "name": self.name,
            "netid": self.netid
        }

    def serialize(self):
        data = self.serialize_without_courses()
        data["courses"] = [s.course.serialize() for s in self.courses]
        return data
