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
def hello_world():
    return "Hello world!"

# ----------- USER ROUTES -------------------------------------------------------------------


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


@app.route("/api/users/<netid>/", methods=['GET'])
def get_user(netid):
    user = User.query.filter_by(netid = netid).first()
    if user is None:
        return failure_response("User not found!")
    return success_response(user.serialize())

@app.route("/api/friends/<netid>/", methods=['GET'])
def get_friends(netid):
    user = User.query.filter_by(netid = netid).first()
    
    return success_response([friend.serialize() for friend in user.friend])

@app.route("/api/users/<netid>/send/", methods=['POST'])
def send_friend_request(netid):
    user = User.query.filter_by(netid = netid).first()
    if user is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    friend_netid = body.get("friend_netid")
    if friend_netid is None:
        return failure_response("Invalid field!")
    friend = User.query.filter_by(netid = friend_netid).first()
    if friend is None:
        return failure_response("User not found!")
    #focus on this
    if friend in user.friend:
        return failure_response("You are already friends!")

    new_request = Friend_request(sender_netid = str(netid), receiver_netid = friend_netid, accepted = "false")
    db.session.add(new_request)
    new_request.sender.append(user)
    new_request.receiver.append(friend)
    user.sent_request.append(new_request)
    friend.received_request.append(new_request)

    db.session.commit()
    return success_response(new_request.serialize(), 201)


@app.route("/api/request/<netid>/", methods=['GET'])
def get_friend_request(netid):
    user = User.query.filter_by(netid = netid).first()
    if user is None:
        return failure_response("User not found!")
    return success_response([request.serialize() for request in user.received_request], 201)


@app.route("/api/users/<netid>/receive/", methods=['POST'])
def receive_friend_request(netid):
    receiver = User.query.filter_by(netid = netid).first()
    if receiver is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    
    request_id = body.get("request_id")
    accepted = body.get("accepted")

    the_request = Friend_request.query.filter_by(id = request_id).first()
    if the_request is None:
        return failure_response("Request not found!")
    
    sender = User.query.filter_by(netid = the_request.sender_netid).first()
    if sender is None:
        return failure_response("User not found!")
    if receiver in sender.friend:
        return failure_response("You are already friends!")
    if accepted not in ("true", "false"):
        return failure_response("Invalid field!")
    
    if accepted == "true":
        the_request.accepted = "true"
        new_friend_to_sender = Friend(me_netid = the_request.sender_netid, friend_netid = str(netid))
        new_friend_to_receiver = Friend(me_netid = str(netid), friend_netid = the_request.sender_netid)
        new_friend_to_sender.me.append(sender)
        new_friend_to_receiver.me.append(receiver)
        db.session.add(new_friend_to_sender)
        db.session.add(new_friend_to_receiver)
        sender.friend.append(new_friend_to_sender)
        receiver.friend.append(new_friend_to_receiver)
    
    receiver.received_request.append(the_request)

    db.session.commit()
    return success_response(the_request.serialize(), 201)


@app.route("/api/friend/<user_netid>/", methods=['DELETE'])
def delete_friend(user_netid):
    user = User.query.filter_by(netid = user_netid).first()
    if user is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    friend_netid = body.get("netid")
    if friend_netid is None:
        return failure_response("Invalid field!")
    friend_table = Friend.query.filer_by(friend_netid = friend_netid).first()
    if friend_table is None:
        return failure_response("Friend not found!")
        friend = User.query.filter_by(netid = friend_table.friend_netid).first()

    if friend is None:
        return failure_response("User not found!")

    user.friend.remove(friend_table)
    db.session.delete(friend_table)
    db.session.commit()
    return success_response(user.serialize(), 201)


# ----------- EVENT ROUTES -------------------------------------------------------------------

@app.route("/api/event/<user_netid>/", methods=['POST'])
def create_event(user_netid):
    creator = User.query.filter_by(netid = user_netid).first()
    if creator is None:
        return failure_response("User not found!")
    body = json.loads(request.data)
    title = body.get("title")
    location = body.get("location")
    time = body.get("time")
    
    description = body.get("description")
    publicity = body.get("publicity")
    tags = body.get("tag")
    
    if title is None or location is None or time is None or description is None:
        return failure_response("Invalid field!")
    new_event = Event(title = title, location = location, time = time, description = description, publicity = publicity)
    db.session.add(new_event)

    new_event.creator.append(creator)
    creator.event_created.append(new_event)
    if tags is not None:
        for i in tags:
            the_tag = Tag.query.filter_by(title = i).first()
            if the_tag is None:
                return failure_response("Invalid tag field!")
            new_event.tag.append(the_tag)
            the_tag.event.append(new_event)

    db.session.commit()
    return success_response(new_event.serialize(), 201)


@app.route("/api/tag/", methods=['POST'])
def create_tag():
    body = json.loads(request.data)
    title = body.get("title")
    if title is None:
        return failure_response("Invalid field!")
    new_tag = Tag(title = title)
    db.session.add(new_tag)
    db.session.commit()
    return success_response(new_tag.serialize(), 201)

@app.route("/api/interestevent/<int:event_id>/", methods=['POST'])
def interest_event(event_id):
    event = Event.query.filter_by(id = event_id).first()
    if event is None:
        return failure_response("Event not found!")
    body = json.loads(request.data)
    user_netid = body.get("user_netid")
    if user_netid is None:
        return failure_response("Invalid field!")
    user = User.query.filter_by(netid = user_netid).first()
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
    user_netid = body.get("user_netid")
    if user_netid is None:
        return failure_response("Invalid field!")
    user = User.query.filter_by(netid = user_netid).first()
    if user is None:
        return failure_response("User not found!")
    if event not in user.event_created or user not in event.creator:
        return failure_response("You have no right to delete this event!")
    db.session.delete(event)
    db.session.commit()
    return success_response(event.serialize())


@app.route("/api/event/<int:event_id>/", methods=["DELETE"])
def remove_interested_event(event_id):
    body = json.loads(request.data)
    event = Event.query.filter_by(id = event_id).first()
    if event is None:
        return failure_response("Event not found!")
    user_netid= body.get("user_netid")
    if user_netid is None:
        return failure_response("Invalid field!")
    user = User.query.filter_by(netid=user_netid).first()
    if user is None:
        return failure_response("User not found!")
    if event not in user.event_interested:
        return failure_response("User has not shown interests to this event!")
    user.event_interested.remove(event)
    
    db.session.commit()
    return success_response(user.serialize())


@app.route("/api/events/")
def get_all_events():
    return success_response([t.serialize() for t in Event.query.all()])


@app.route("/api/events/<user_netid>/")
def get_all_events_for_user(user_netid):
    user = User.query.filter_by(netid = user_netid).first()
    if user is None:
        return failure_response("User not found!")   
    response = []
    for e in Event.query.all():
        if e.publicity == "True":
            response.append(e.serialize())
        #what if the initiator wants to let all friends to view the event?
        elif e.publicity == "False":
            isFriend = False
            if user in e.creator:
                isFriend = True
            for f in user.friend:
                for c in e.creator:
                    if f.friend_netid == c.netid:
                        isFriend = True
            if isFriend == True:
                response.append(e.serialize())
            
    return success_response(response)



@app.route("/api/events/<user_netid>/tag/")
def get_all_events_for_user_tag(user_netid):
    body = json.loads(request.data)
    tags = body.get("tag")

    user = User.query.filter_by(netid = user_netid).first()
    if user is None:
        return failure_response("User not found!")   
    response = []
    for e in Event.query.all():
        for t in tags:
            tag_cur = Tag.query.filter_by(title = t).first()
            if tag_cur in e.tag:
                if e.publicity == "True":
                    response.append(e.serialize())
                #what if the initiator wants to let all friends to view the event?
                elif e.publicity == "False":
                    isFriend = False
                    if user in e.creator:
                        isFriend = True
                    for f in user.friend:
                        for c in e.creator:
                            if f.friend_netid == c.netid:
                                isFriend = True
                    if isFriend == True:
                        response.append(e.serialize())
            
    return success_response(response)

@app.route("/api/event/<int:event_id>/")
def get_event(event_id): 
    body = json.loads(request.data)
    event = Event.query.filter_by(id = event_id).first()
    user_netid = body.get("user_netid")
    
    if user_netid is None:
        return failure_response("User not found!") 
    if event is None:
        return failure_response("Event not found!")
    if event.publicity == "False":
        user = User.query.filter_by(netid = user_netid).first()
        if user is None:
            return failure_response("User not found!")
        isFriend = False
        if user in event.creator:
                isFriend = True
        for f in user.friend:
            for c in event.creator:
                if f.friend_netid == c.netid:
                    isFriend = True
        if isFriend == False:
            return failure_response("You have no access!")
    
    return success_response(event.serialize())


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
