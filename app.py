from db import db
from db import Event, Tag, User, Friend, Friend_request
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

# TODO: Function for updating for all the fields

@app.route("/api/users/", methods=['POST'])
def create_user():
    body = json.loads(request.data)
    n = body.get("name")
    nid = body.get("netid")
    scct = body.get("social_account")
    pswd = body.get("password")
    if nid is None or n is None or scct is None or pswd is None:
        return failure_response("Invalid field!")
    
    new_user = User(name = n, netid = nid, social_account = scct, password = pswd)
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)


@app.route("/api/users/<int:id>/", methods=['GET'])
def get_user(id):
    user = User.query.filter_by(id = id).first()
    if user is None:
        return failure_response("User not found!")
    return success_response(user.serialize())

@app.route("/api/friends/<int:id>/", methods=['GET'])
def get_friends(id):
    user = User.query.filter_by(id = id).first()
    
    return success_response([friend.serialize() for friend in user.friend])

@app.route("/api/users/<int:id>/send/", methods=['POST'])
def send_friend_request(id):
    user = User.query.filter_by(id = id).first()
    if user is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    friend_id = body.get("friend_id")
    if friend_id is None:
        return failure_response("Invalid field!")
    friend = User.query.filter_by(id = friend_id).first()
    if friend is None:
        return failure_response("User not found!")
    if friend in user.friend:
        return failure_response("You are already friends!")

    new_request = Friend_request(sender_id = str(id), receiver_id = friend_id, accepted = "false")
    db.session.add(new_request)
    new_request.sender.append(user)
    new_request.receiver.append(friend)
    user.sent_request.append(new_request)
    friend.received_request.append(new_request)

    db.session.commit()
    return success_response(new_request.serialize(), 201)


@app.route("/api/requests/<int:request_id>/", methods=['GET'])
def get_friend_request(request_id):
    request = Friend_request.query.filter_by(id = request_id).first()
    if request is None:
        return failure_response("Request not found!")
    return success_response(request.serialize(), 201)


@app.route("/api/users/<int:id>/receive/", methods=['POST'])
def receive_friend_request(id):
    receiver = User.query.filter_by(id = id).first()
    if receiver is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    request_id = body.get("request_id")
    accepted = body.get("accepted")
    the_request = Friend_request.query.filter_by(id = request_id).first()
    if the_request is None:
        return failure_response("Request not found!")
    
    sender = User.query.filter_by(id = the_request.sender_id).first()
    if sender is None:
        return failure_response("User not found!")
    if receiver in sender.friend:
        return failure_response("You are already friends!")
    if accepted not in ("true", "false"):
        return failure_response("Invalid field!")
    
    if accepted == "true":
        the_request.accepted = "true"
        new_friend_to_sender = Friend(friend_id = str(id))
        new_friend_to_receiver = Friend(friend_id = the_request.sender_id)
        new_friend_to_sender.me.append(sender)
        new_friend_to_receiver.me.append(receiver)
        db.session.add(new_friend_to_sender)
        db.session.add(new_friend_to_receiver)
        sender.friend.append(new_friend_to_sender)
        receiver.friend.append(new_friend_to_receiver)
    
    receiver.received_request.append(the_request)

    db.session.commit()
    return success_response(the_request.serialize(), 201)


@app.route("/api/requests/<int:user_id>/", methods=['DELETE'])
def delete_friend(user_id):
    user = User.query.filter_by(id = id).first()
    if user is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    friend_table_id = body.get("friend_table_id")
    if friend_table_id is None:
        return failure_response("Invalid field!")
    friend_table = Friend.query.filer_by(id = friend_table_id).first()
    if friend_table is None:
        return failure_response("Friend not found!")
    friend = User.query.filter_by(id = friend_table.friend_id).first()
    if friend is None:
        return failure_response("User not found!")

    user.friend.remove(friend_table)
    db.session.delete(friend_table)
    db.session.commit()
    return success_response(user.serialize(), 201)


# ----------- EVENT ROUTES -------------------------------------------------------------------

#still working on tag part
@app.route("/api/event/<int:user_id>/", methods=['POST'])
def create_event(user_id):
    creator = User.query.filter_by(id = user_id).first()
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
    new_event = Event(title = title, location = location, time = time, description = description, publicity = publicity, tag = tag)
    db.session.add(new_event)

    new_event.creator.append(creator)
    creator.event_created.append(new_event)

    db.session.commit()
    return success_response(new_event.serialize(), 201)


@app.route("/api/interestevent/<int:event_id>/", methods=['POST'])
def interest_event(event_id):
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
    if event in user.event_interested:
        return failure_response("You have already shown interest to this event!")
    user.event_interested.append(event)
    event.attender.append(user)
    db.session.commit()
    return success_response(user.serialize())
    

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
    if event not in user.event_created or user is not event.creator:
        return failure_response("You have no right to delete this event!")
    db.session.delete(event)
    db.session.commit()
    return success_response(event.serialize())


@app.route("/api/event/<int:event_id>/", methods=["DELETE"])
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
    return success_response(user.serialize())


#still working on publicity, dyj: user_id should be in the route I think
@app.route("/api/events/")
def get_all_events():
    body = json.loads(request.data)
    user = body.get("user_id")
    response = []
    for e in Event.query.all():
        if e.publicity is True:
            response += e.serialize()
        #what if the initiator wants to let all friends to view the event?
        elif e.publicity is False:
            if Friend.query.filter_by(me_id = e.creator.id, friend_id = user).first() is not None:
                response.append(e.serialize())
    
    return success_response(response)

@app.route("/api/events/<int:event_id>/")
def get_event(event_id): 
    event = Event.query.filter_by(id = event_id).first()
    if event is None:
        return failure_response("Event not found!")
    if e.publicity is 0:
            if Friend.query.filter_by(me_id = e.creator.id, friend_id = user).first() is None:
                return failure_response("you have no access")
    
    return success_response(event.serialize())



    


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
