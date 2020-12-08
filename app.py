from db import db
from db import Event, Tag, User, Friend
from flask import Flask, request
import json
import os

app = Flask(__name__)
db_filename = "meet-in-event.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code = 200):
    return json.dumps({"success": True, "data": data}), code
def failure_response(message, code = 404):
    return json.dumps({"success": False, "error": message}), code

@app.route("/")

# ----------- USER ROUTES -------------------------------------------------------------------

@app.route("/api/users/", methods=['POST'])
def create_user():
    body = json.loads(request.data)
    n = body.get("name")
    nid = body.get("netid")
    scct = body.get("social_account")
    if nid is None or n is None or scct is None:
        return failure_response("Invalid field!")
    
    new_user = User(netid = nid, name = n, social_account = scct)
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)

@app.route("/api/users/<int:id>/")
def get_user(id):
    user = User.query.filter_by(id = id).first()
    if user is None:
        return failure_response("User not found!")
    return success_response(user.serialize2())

@app.route("/api/users/<int:id>/send/")
def send_friend_request(id):
    user = User.query.filter_by(id = id).first()
    if user is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    friend_id = body.get("friend_id")
    catagory = body.get("catagory") #sender's
    if friend_id or catagory is None:
        return failure_response("Invalid field!")
    friend = User.query.filer_by(id = friend_id).first()
    if friend is None:
        return failure_response("User not found!")

    new_request = Friend(sender_id = id, receiver_id = friend_id, sender_catagory = catagory, accepted = "false")
    db.session.add(new_request)
    db.session.commit()
    return success_response(new_request.serialize(), 201)

@app.route("/api/users/<int:id>/receive/")
def receive_friend_request(id):
    request = Friend.query.filter_by(id = id).first()
    if request is None:
        return failure_response("Request not found!")
    body = json.loads(request.data)
    sender_id = body.get("sender_id")
    receiver_id = body.get("receiver_id")
    catagory = body.get("catagory") #receiver's
    accepted = body.get("accepted")
    if sender_id or receiver_id is None:
        return failure_response("Invalid field!")
    sender = User.query.filer_by(id = sender_id).first()
    receiver = User.query.filer_by(id = receiver_id).first()
    if sender or receiver is None:
        return failure_response("User not found!")
    if accepted is not "true" or "false":
        return failure_response("Invalid field!")
    
    if accepted is "true":
        request.accepted = "true"
        request.receiver_catagory = catagory
        sender.sent_request.append(request)
        receiver.received_request.append(request)

    db.session.commit()
    return success_response(request.serialize(), 201)

# ----------- EVENT ROUTES -------------------------------------------------------------------

#still working on tag part
@app.route("/api/event/<int:user_id>/", methods=['POST'])
def create_event(user_id):
    creator = User.query.filer_by(id = user_id).first()
    if creator is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    title = body.get("title")
    location = body.get("location")
    time = body.get("time")
    description = body.get("description")
    publicity = body.get("publicity")
    tag = body.get("tag")
    
    if title is None or location is None or time is None or description is None:
        return failure_response("Invalid field!")
    new_event = Event(title = title, location = location, time = time, descrption = descrition, publicity = publicity)
    db.session.add(new_event)

    new_event.creator.append(creator)
    user.event_created.append(new_event)

    db.session.commit()
    return success_response(new_event.serialize(), 201)


@app.route("/api/events/<int:event_id>/", methods=["DELETE"])
def delete_event(event_id): 
    event = Event.query.filter_by(id = event_id).first()
    if event is None:
        return failure_response("Event not found!")
    body = json.loads(request.data)
    user_id = body.get("user_id")
    if user_id is None:
        return failure_response("Invalid field!")
    user = User.query.filter_by(id = user_id).first()
    if user is None:
        return failure_response("User not found!")
    if event is not in user.event_created or user is not event.creator:
        return failure_response("You have no right to delete this event!")
    if password is not user.password:
        return failure_response("Please recheck the password!")
    db.session.delete(event)
    db.session.commit()
    return success_response(course.serialize())


@app.route("/api/event/<int:event_id>/drop/", methods=["DELETE"])
def delete_interested_event(event_id):
    body = json.loads(request.data)
    event = Event.query.filter_by(id = event_id).first()
    if event is None:
        return failure_response("Event not found!")
    user_id=body.get("user_id")
    if user_id is None:
        return failure_response("Invalid field!")
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    if event not in user.event_interested:
        return failure_response("User has not shown interests to this event!")
    user.event_interested.remove(event)
    
    db.session.commit()
    return success_response(user.serialize2())


#still working on publicity
@app.route("/api/events/")
def get_all_events():
    body = json.loads(request.data)
    user = body.get("user_id")
    response = []
    for e in Event.query.all():
        if e.publicity is None:
            response.append(e.serialize())
        elif e.publicity is "friend_only":
            if user is in e.creator.friends:
                #just finished the friends' methods, next step: make a whole list of friends
                response.append(e.serialize())

    return success_response([c.serialize() for c in response.query.all()])


@app.route("/api/courses/<int:event_id>/")
def get_event(event_id): 
    event = Event.query.filter_by(id = event_id).first()
    if event is None:
        return failure_response("Event not found!")
    
    return success_response(event.serialize())

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)