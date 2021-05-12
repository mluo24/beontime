import json

import arrow
from flask import Flask
import requests
import datetime

from db import db, Course, Assignment, User

from flask import request

app = Flask(__name__)

db_filename = "beontime.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


def get_user_by_email(email):
    return User.query.filter(User.email == email).first()


def get_user_by_session_token(session_token):
    return User.query.filter(User.session_token == session_token).first()


def get_user_by_update_token(update_token):
    return User.query.filter(User.update_token == update_token).first()


def extract_token(request):
    auth_header = request.headers.get("Authorization")
    if auth_header is None:
        return False, json.dumps({"error": "Missing auth header"})

    bearer_token = auth_header.replace("Bearer ", "").strip()
    if bearer_token is None or not bearer_token:
        return False, json.dumps({"error": "Invalid auth header"})
    return True, bearer_token


def split_chars(string):
    chars = []
    for c in string:
        chars.append(c)
    return chars


def extract_relevant_course_data(class_data):
    days_and_times = {}
    enroll_groups = class_data["enrollGroups"]
    for g in enroll_groups:
        sections = g["classSections"]
        main_mode = "LEC"
        if len(sections) > 0:
            main_mode = sections[0]["ssrComponent"]
        for d in sections:
            if d["ssrComponent"] == main_mode:
                for m in d["meetings"]:
                    if days_and_times.get(m["pattern"]):
                        if m["pattern"] != "":
                            days_and_times[m["pattern"]].append(m["timeStart"])
                    else:
                        if m["pattern"] == "":
                            days_and_times["unavailable"] = []
                        else:
                            days_and_times[m["pattern"]] = [m["timeStart"]]
    return {
        "subject": class_data["subject"],
        "code": class_data["catalogNbr"],
        "name": class_data["titleLong"],
        "days_and_times": days_and_times
    }


def get_datetime_from_string(d):
    return datetime.datetime.strptime(d, '%a, %b %d, %Y @ %I:%M%p')


def get_time_from_string(t):
    return datetime.datetime.strptime(t, '%I:%M%p').time()


# generalized response formats
def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}), code


def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code


BASE_SUBJ_URL = "https://classes.cornell.edu/api/2.0/config/subjects.json?roster=SP21"

BASE_SEARCH_URL = "https://classes.cornell.edu/api/2.0/search/classes.json?roster=SP21"


# --------------------ENDPOINTS START HERE--------------------

# course endpoints (includes external APIs)

@app.route('/api/courses-api/subjects/')
def get_all_subjects_api():
    res = requests.get(BASE_SUBJ_URL)
    body = res.json()
    data = body["data"]["subjects"]
    return success_response(data)


@app.route('/api/courses-api/<subject>/')
def get_courses_from_subject_api(subject):
    subject = subject.upper()
    res = requests.get(BASE_SEARCH_URL + f"&subject={subject}")
    body = res.json()
    if body["status"] == "error":
        return failure_response("Subject not found.")
    rel_classes_info = [extract_relevant_course_data(c) for c in body["data"]["classes"]]
    return success_response(rel_classes_info)


@app.route('/api/courses-api/<subject>/<number>/')
def get_course_from_subject_and_number_api(subject, number):
    res = requests.get(BASE_SEARCH_URL + f"&subject={subject}&q={number}")
    body = res.json()
    if body["status"] == "error":
        return failure_response("Class not found.")
    class_data = body["data"]["classes"][0]
    return success_response(extract_relevant_course_data(class_data))


@app.route('/api/courses/')
def get_all_courses():
    if secret_message().find("message") != -1:
        success, session_token = extract_token(request)
        user = get_user_by_session_token(session_token)
        courses = [c.serialize() for c in user.courses]
        return success_response(courses)
    return failure_response("Failed to authenticate" + secret_message().get("error"), 401)


@app.route('/api/courses/', methods=["POST"])
def add_course():
    if secret_message().find("message") != -1:
        body = json.loads(request.data)
        subject = body.get("subject")
        code = body.get("code")
        name = body.get("name")
        days_on = body.get("days_on")
        time = body.get("time")
        success, session_token = extract_token(request)
        user = get_user_by_session_token(session_token)
        user_id = user.id
        if subject is None or code is None or name is None:
            return failure_response("Subject, code, and name fields are required.", 400)
        new_course = Course(
            subject=subject,
            code=code,
            name=name,
            days_on=days_on,
            time=get_time_from_string(time),
            user_id=user_id
        )
        db.session.add(new_course)
        db.session.commit()
        return success_response(new_course.serialize(), 201)
    return failure_response("Fail to log in", 401)


@app.route("/api/courses/<int:course_id>/")
def get_course_by_id(course_id):
    if secret_message().find("message") != -1:
        course = Course.query.filter_by(id=course_id).first()
        if course is None:
            return failure_response("Course not found")
        return success_response(course.serialize())
    return failure_response("Fail to log in", 401)


@app.route("/api/courses/<int:course_id>/", methods=["POST"])
def update_course(course_id):
    if secret_message().find("message") != -1:
        course = Course.query.filter_by(id=course_id).first()
        if course is None:
            return failure_response("Course not found")
        body = json.loads(request.data)
        subject = body.get("subject", course.subject)
        code = body.get("code", course.code)
        name = body.get("name", course.name)
        days_on = body.get("days_on", course.days_on)
        time = get_time_from_string(body.get("time", course.time))
        course.subject = subject
        course.code = code
        course.name = name
        course.days_on = days_on
        course.time = time

        db.session.commit()
        return success_response(course.serialize())
    return failure_response("Fail to log in", 401)


@app.route('/api/courses/<int:course_id>/', methods=["DELETE"])
def delete_course(course_id):
    if secret_message().find("message") != -1:
        course = Course.query.filter_by(id=course_id).first()
        if course is None:
            return failure_response("Course not found!")
        db.session.delete(course)
        db.session.commit()
        return success_response(course.serialize())
    return failure_response("Fail to log in", 401)


@app.route('/api/courses/<int:course_id>/assignments/')
def get_assignments_from_course(course_id):
    if secret_message().find("message") != -1:
        group = request.args.get('group', "none")
        course = Course.query.filter_by(id=course_id).first()
        if course is None:
            return failure_response("Class not found.")
        # assignments_serialized = []
        # for a in course.assignments:
        #     assignments_serialized.append(a.serialize_without_course())
        current_assignments_total = [a for a in course.assignments if not a.done]
        if group == "priority":
            assignments_serialized = {
                "high": [a.serialize() for a in current_assignments_total if a.priority == "high"],
                "medium": [a.serialize() for a in current_assignments_total if a.priority == "medium"],
                "low": [a.serialize() for a in current_assignments_total if a.priority == "low"],
                "none": [a.serialize() for a in current_assignments_total if a.priority == "none"]
            }
        elif group == "type":
            assignments_serialized = {
                "assignment": [a.serialize() for a in current_assignments_total if a.type == "assignment"],
                "project": [a.serialize() for a in current_assignments_total if a.type == "project"],
                "quiz": [a.serialize() for a in current_assignments_total if a.type == "quiz"],
                "exam": [a.serialize() for a in current_assignments_total if a.type == "exam"],
            }
        else:
            today = [a for a in current_assignments_total
                     if a.due_date.date() == datetime.datetime.today().date()]
            tomorrow = [a for a in current_assignments_total
                        if a.due_date.date() == (datetime.datetime.today() + datetime.timedelta(days=1)).date()]
            next_seven_days = [a for a in current_assignments_total
                               if a.due_date.date() <= (datetime.datetime.today() + datetime.timedelta(days=7)).date()
                               and not (a in today) and not (a in tomorrow)]
            for_later = [a for a in current_assignments_total
                         if not (a in today) and not (a in tomorrow) and not (a in next_seven_days)]
            assignments_serialized = {
                "for_today": [a.serialize() for a in today],
                "for_tomorrow": [a.serialize() for a in tomorrow],
                "for_next_seven_days": [a.serialize() for a in next_seven_days],
                "for_later": [a.serialize() for a in for_later]
            }

        return success_response(assignments_serialized)
    return failure_response("Fail to log in", 401)


@app.route('/api/courses/<int:course_id>/assignments/', methods=["POST"])
def add_assignment_to_course(course_id):
    if secret_message().find("message") != -1:
        course = Course.query.filter_by(id=course_id).first()
        if course is None:
            return failure_response("Course not found!")
        body = json.loads(request.data)
        title = body.get("title")
        due_date = body.get("due_date")
        description = body.get("description")
        priority = body.get("priority")
        type = body.get("type")
        success, session_token = extract_token(request)
        user = get_user_by_session_token(session_token)
        user_id = user.id
        if title is None or due_date is None or description is None or priority is None or type is None:
            return failure_response("All fields are required.", 400)
        new_assignment = Assignment(
            title=title,
            due_date=get_datetime_from_string(due_date),
            description=description,
            priority=priority,
            type=type,
            done=False,
            course_id=course_id,
            user_id=user_id
        )
        db.session.add(new_assignment)
        db.session.commit()
        return success_response(new_assignment.serialize())
    return failure_response("Fail to log in", 401)


# assignment endpoints
@app.route('/api/assignments/')
def get_all_assignments():
    if secret_message().find("message") != -1:
        group = request.args.get('group', "none")
        success, session_token = extract_token(request)
        user = get_user_by_session_token(session_token)
        current_assignments_total = \
            [a for a in
             Assignment.query.filter_by(done=False, user_id=user.id).order_by(Assignment.due_date.asc()).all()]
        past_assignments = \
            [a.serialize() for a in
             Assignment.query.filter_by(done=True, user_id=user.id).order_by(Assignment.due_date.asc()).all()]
        if group == "priority":
            current_assignments = {
                "high": [a.serialize() for a in current_assignments_total if a.priority == "high"],
                "medium": [a.serialize() for a in current_assignments_total if a.priority == "medium"],
                "low": [a.serialize() for a in current_assignments_total if a.priority == "low"],
                "none": [a.serialize() for a in current_assignments_total if a.priority == "none"]
            }
        elif group == "type":
            current_assignments = {
                "assignment": [a.serialize() for a in current_assignments_total if a.type == "assignment"],
                "project": [a.serialize() for a in current_assignments_total if a.type == "project"],
                "quiz": [a.serialize() for a in current_assignments_total if a.type == "quiz"],
                "exam": [a.serialize() for a in current_assignments_total if a.type == "exam"],
            }
        else:
            today = [a for a in current_assignments_total
                     if a.due_date.date() == datetime.datetime.today().date()]
            tomorrow = [a for a in current_assignments_total
                        if a.due_date.date() == (datetime.datetime.today() + datetime.timedelta(days=1)).date()]
            next_seven_days = [a for a in current_assignments_total
                               if a.due_date.date() <= (datetime.datetime.today() + datetime.timedelta(days=7)).date()
                               and not (a in today) and not (a in tomorrow)]
            for_later = [a for a in current_assignments_total
                         if not (a in today) and not (a in tomorrow) and not (a in next_seven_days)]
            current_assignments = {
                "for_today": [a.serialize() for a in today],
                "for_tomorrow": [a.serialize() for a in tomorrow],
                "for_next_seven_days": [a.serialize() for a in next_seven_days],
                "for_later": [a.serialize() for a in for_later]
            }
        return success_response({
            "current_assignments": current_assignments,
            "past_assignments": past_assignments
        })
    return failure_response("Fail to log in", 401)


@app.route('/api/assignments/<int:assignment_id>/')
def get_assignment(assignment_id):
    if secret_message().find("message") != -1:
        assignment = Assignment.query.filter_by(id=assignment_id).first()
        if assignment is None:
            return failure_response("Assignment not found!")
        return success_response(assignment.serialize())
    return failure_response("Fail to log in", 401)


@app.route("/api/assignments/<int:assignment_id>/", methods=["POST"])
def update_assignment(assignment_id):
    if secret_message().find("message") != -1:
        assignment = Assignment.query.filter_by(id=assignment_id).first()
        if assignment is None:
            return failure_response("Assignment not found")
        body = json.loads(request.data)
        title = body.get("title", assignment.title)
        due_date = body.get("due_date", arrow.get(assignment.due_date).format("ddd, MMM D, YYYY @ h:mmA"))
        description = body.get("description", assignment.description)
        priority = body.get("priority", assignment.priority)
        assignment_type = body.get("type", assignment.type)
        assignment.title = title
        assignment.due_date = get_datetime_from_string(due_date)
        assignment.description = description
        assignment.priority = priority
        assignment.type = assignment_type
        assignment.done = assignment.done

        db.session.commit()
        return success_response(assignment.serialize())
    return failure_response("Fail to log in", 401)


@app.route('/api/assignments/<int:assignment_id>/done/', methods=["POST"])
def mark_assignment_as_done(assignment_id):
    if secret_message().find("message") != -1:
        assignment = Assignment.query.filter_by(id=assignment_id).first()
        if assignment is None:
            return failure_response("Assignment not found")
        assignment.done = True
        db.session.commit()
        return success_response(assignment.serialize())
    return failure_response("Fail to log in", 401)


@app.route('/api/assignments/<int:assignment_id>/', methods=["DELETE"])
def delete_assignment(assignment_id):
    if secret_message().find("message") != -1:
        assignment = Assignment.query.filter_by(id=assignment_id).first()
        if assignment is None:
            return failure_response("Assignment not found!")
        db.session.delete(assignment)
        db.session.commit()
        return success_response(assignment.serialize())
    return failure_response("Fail to log in", 401)


@app.route('/api/assignments/done/', methods=["POST"])
def mark_assignments_as_done_in_bulk():
    if secret_message().find("message") != -1:
        body = json.loads(request.data)
        assignments = body.get("assignments", [])
        for assignment_id in assignments:
            assignment = Assignment.query.filter_by(id=assignment_id).first()
            if assignment is None:
                return failure_response("One of these assignments not found!")
            assignment.done = True
            db.session.commit()
        return success_response(
            [Assignment.query.filter_by(id=assignment_id).first().serialize() for assignment_id in assignments])
    return failure_response("Fail to log in", 401)


@app.route('/api/assignments/', methods=["DELETE"])
def delete_assignments_in_bulk():
    if secret_message().find("message") != -1:
        body = json.loads(request.data)
        assignments = body.get("assignments", [])
        deleted_assignments = []
        for assignment_id in assignments:
            assignment = Assignment.query.filter_by(id=assignment_id).first()
            if assignment is None:
                return failure_response("One of these assignments not found!")
            deleted_assignments.append(assignment)
            db.session.delete(assignment)
            db.session.commit()
        return success_response(
            [a.serialize() for a in deleted_assignments])
    return failure_response("Fail to log in", 401)

# AUTHENTICATION ROUTES


# User login endpoint
@app.route('/login/', methods=["POST"])
def login():
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password")
    if email is None or password is None:
        return json.dumps({"error": "Invalid email or password"})
    user = get_user_by_email(email)
    success = user is not None and user.verify_password(password)
    if not success:
        return json.dumps({"error": "Incorrect email or password"})
    return json.dumps(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token,
        }
    )


# User register endpoint
@app.route('/register/', methods=["POST"])
def register_account():
    body = json.loads(request.data)
    email = body.get("email")
    password = body.get("password")
    name = body.get("name")
    netid = body.get("netid")
    if email is None or password is None:
        return json.dumps({"error": "Invalid email or password"})
    optional_user = get_user_by_email(email)
    if optional_user is not None:
        return json.dumps({"error": "User already exists."})
    user = User(email=email, password=password,name=name,netid=netid)
    db.session.add(user)
    db.session.commit()
    return json.dumps(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token,
            "name": name,
            "netid": netid
        }
    )


# User session update token endpoint
@app.route('/session/', methods=["POST"])
def update_session():
    success, update_token = extract_token(request)

    if not success:
        return update_token

    user = get_user_by_update_token(update_token)

    if user is None:
        return json.dumps({"error": f"Invalid update token: {update_token}"})
    user.renew_session()
    db.session.commit()
    return json.dumps(
        {
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token,
        }
    )


@app.route('/secret/', methods=["GET"])
def secret_message():
    success, session_token = extract_token(request)

    if not success:
        return session_token

    user = get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return json.dumps({"error": "Invalid session token"})

    return json.dumps({"message": "You have successfully implemented sessions."})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
