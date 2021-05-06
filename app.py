import json

from flask import Flask
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
    return User.query.filter(User.email==email).first()

def get_user_by_session_token(session_token):
    return User.query.filter(User.session_token==session_token).first()

def get_user_by_update_token(update_token):
    return User.query.filter(User.update_token==update_token).forst()

def extract_token(request):
    auth_header=request.headers.get("Authorization")
    if auth_header is None:
        return False, json.dumps({"error": "Missing auth header"})
    
    bearer_token=auth_header.replace("Bearer ","").strip()
    if bearer_token is None or not bearer_token:
        return False, json.dumps({"error": "Invalid auth header"})
    return True, bearer_token



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

#User login endpoint
@app.route('/login/',methods=["POST"])
def login():
    body = json.loads(request.data)
    email=body.get("email")
    password=body.get("password")
    if email is None or password is NOne:
        return json.dumps({"error": "Invalid email or password"})
    user=get_user_by_email(email)
    success=user is not None and user.verigy.password(password)
    if not sucess:
        return json.dumps({"error": "Incorrect email or password"})
    return json.dumps(
        {
            "session_token":user.session_token,
            "session_expiration":str(user.session_expiration),
            "update_token":user.update_token,
        }
    )
    

#User register endpoint
@app.route('/register/',methods=["POST"])
def register_account():
    body = json.loads(request.data)
    email=body.get("email")
    password=body.get("password")
    if email is None or password is NOne:
        return json.dumps({"error": "Invalid email or password"})
    optional_user=get_user_by_email(email)
    if optional_user is not None:
        return json.dumps({"error": "User already exists."})
    User=User(email=email,password=password)
    db.sessions.add(user)
    db.session.commit()
    return json.dumps(
        {
            "session_token":user.session_token,
            "session_expiration":str(user.session_expiration),
            "update_token":user.update_token,
        }
    )

#User session update token endpoint
@app.route('/session/',methods=["POST"])
def update_session():
    sucess, update_token=extract_token(request)
    
    if not sucess:
        return update_token
    
    user=get_user_by_update_token(update_token)
    
    if user is None:
        return json.dumps({"error":f"Invalid update token: {update_token}"})
    user.renew_session()
    db.session.commit()
    return json.dumps(
        {
            "session_token":user.session_token,
            "session_expiration":str(user.session_expiration),
            "update_token":user.update_token,
        }
    )

#User message endpoint
@app.route('/secret/',methods=["GET"])
def secret_message():
    sucess, session_token=extract_token(request)
    
    if not sucess:
        return session_token
    
    user=get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return json.dumps({"error": "Invalid session token"})
    
    return json.dumps({"message": "You have successfully implemented sessions."})
                                
    
    




if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
