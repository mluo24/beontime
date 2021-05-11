import json

from flask import Flask
import requests

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


# generalized response formats
def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}), code


def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code


BASE_SUBJ_URL = "https://classes.cornell.edu/api/2.0/config/subjects.json?roster=SP21"

BASE_SEARCH_URL = "https://classes.cornell.edu/api/2.0/search/classes.json?roster=SP21"


# --------------------ENDPOINTS START HERE--------------------
#     def get_all_subjects(self):
#         res = requests.get(self.api_url_search + f"&subject={self.subject}")
#         body = res.json()
#         return body
#
#     def get_all_courses_from_subjects(self):
#         res = requests.get(f"https://classes.cornell.edu/api/2.0/search/classes.json?roster=SP21&subject={self.subject}")
#         body = res.json()
#         return body

# course endpoints (includes external APIs
@app.route('/api/courses/')
def get_courses():
    if(secret_message().find("message")!=-1):
    
        courses = [c.serialize() for c in Course.query.all()]
        return success_response(courses)
    return failure_response("Fail to log in")
    


@app.route('/api/coursesextra/')
def get_courses_api():
    if(secret_message().find("message")!=-1):
        res = requests.get("https://classes.cornell.edu/api/2.0/search/classes.json?roster=SP21&subject=CS")
        body = res.json()
        return success_response(body["data"]["classes"])
    return failure_response("Fail to log in")


@app.route('/api/courses-api/subjects/')
def get_all_subjects_api():
    if(secret_message().find("message")!=-1):
        res = requests.get(BASE_SUBJ_URL)
        body = res.json()
        data = body["data"]["subjects"]
        return success_response(data)
    return failure_response("Fail to log in")


@app.route('/api/courses-api/<subject>/')
def get_courses_from_subject_api(subject):
    if(secret_message().find("message")!=-1):
        subject = subject.upper()
        res = requests.get(BASE_SEARCH_URL + f"&subject={subject}")
        body = res.json()
        if body["status"] == "error":
            return failure_response("Subject not found.")
        return success_response(body["data"]["classes"])
    return failure_response("Fail to log in")


@app.route('/api/courses-api/<subject>/<number>/')
def get_course_from_subject_and_number_api(subject, number):
    if(secret_message().find("message")!=-1):
        res = requests.get(BASE_SEARCH_URL + f"&subject={subject}&q={number}")
        body = res.json()
        if body["status"] == "error":
            return failure_response("Class not found.")
        return success_response(body["data"]["classes"][0])
    return failure_response("Fail to log in")


@app.route('/api/courses/<string:subject>/<int:number>/assignments/')
def get_assignments_from_course(subject, number):
    if(secret_message().find("message")!=-1):
        res = requests.get(BASE_SEARCH_URL + f"&subject={subject}&q={number}")
        body = res.json()
        if body["status"] == "error":
            return failure_response("Class not found.")
        return success_response(body["data"]["classes"][0])
    return failure_response("Fail to log in")


# assignment endpoints
@app.route('/api/assignments/')
def get_all_assignments():
    if(secret_message().find("message")!=-1):
        assignments = [a.serialize() for a in Assignment.query.all()]
        return success_response(assignments)
    return failure_response("Fail to log in")


@app.route('/api/assignments/')
def get_all_assignments_by_group():
    if(secret_message().find("message")!=-1):
        # do a sort by group
        assignments = [a.serialize() for a in Assignment.query.all()]
        return success_response(assignments)
    return failure_response("Fail to log in")       


@app.route('/api/assignments/<int:assignment_id>')
def get_assignment(assignment_id):
    if(secret_message().find("message")!=-1):
        assignment = Assignment.query.filter_by(id=assignment_id).first()
        if assignment is None:
            return failure_response("Assignment not found!")
        return success_response(assignment.serialize())
    return failure_response("Fail to log in")


@app.route("/api/assignment/<int:assignment_id>/", methods=["POST"])
def update_assignment(assignment_id):
    if(secret_message().find("message")!=-1):
        assignment = Assignment.query.filter_by(id=assignment_id).first()
        if assignment is None:
            return failure_response("Assignment not found")
        body = json.loads(request.data)
        title = body.get("title", assignment.title)
        due_date = body.get("due_date", assignment.due_date)
        assignment.title = title
        assignment.due_date = due_date
        assignment.done = assignment.done

        db.session.commit()
        return success_response(assignment.serialize())
    return failure_response("Fail to log in")


@app.route('/api/assignments/<int:assignment_id>/done', methods=["POST"])
def mark_assignment_as_done(assignment_id):
    if(secret_message().find("message")!=-1):
        assignment = Assignment.query.filter_by(id=assignment_id).first()
        if assignment is None:
            return failure_response("Assignment not found")

        # body = json.loads(request.data)
        title = assignment.title
        due_date = assignment.due_date
        assignment.title = title
        assignment.due_date = due_date
        assignment.done = True
        db.session.commit()
        return success_response(assignment.serialize())
    return failure_response("Fail to log in")


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
            "netid":netid
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
