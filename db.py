from flask_sqlalchemy import SQLAlchemy
import base64
import boto3
import datetime
from io import BytesIO
from mimetypes import guess_extension, guess_type #know what type of file we are parsing
import os #know the directory we are working at
from PIL import Image
import random
import re
import string

db = SQLAlchemy()

EXTENSIONS = ["png", "gif", "jpg", "jpeg"]
BASE_DIR = os.getcwd()
S3_BUCKET = "melindademo"
S3_BASE_URL = f"https://{S3_BUCKET}.s3-us-east-2.amazonaws.com"


association_table_1 = db.Table(
    "event_creator",
    db.Model.metadata,
    db.Column("event_id", db.Integer, db.ForeignKey("event.id")),
    db.Column("user_netid", db.Integer, db.ForeignKey("user.netid"))
)

association_table_2 = db.Table(
    "event_attendor",
    db.Model.metadata,
    db.Column("event_id", db.Integer, db.ForeignKey("event.id")),
    db.Column("user_netid", db.Integer, db.ForeignKey("user.netid"))
)

association_table_3 = db.Table(
    "event_tag",
    db.Model.metadata,
    db.Column("event_id", db.Integer, db.ForeignKey("event.id")),
    db.Column("tag_id", db.Integer, db.ForeignKey("tag.id"))
)

association_table_4 = db.Table(
    "request_sender",
    db.Model.metadata,
    db.Column("request_id", db.Integer, db.ForeignKey("friend_request.id")),
    db.Column("sender_netid", db.Integer, db.ForeignKey("user.netid"))
)

association_table_5 = db.Table(
    "request_receiver",
    db.Model.metadata,
    db.Column("request_id", db.Integer, db.ForeignKey("friend_request.id")),
    db.Column("receiver_netid", db.Integer, db.ForeignKey("user.netid"))
)

association_table_6 = db.Table(
    "friend_me",
    db.Model.metadata,
    db.Column("friend_netid", db.Integer, db.ForeignKey("friend.friend_netid")),
    db.Column("me_netid", db.Integer, db.ForeignKey("user.netid"))
)


class Event(db.Model):
    __tablename__ = "event"
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    location = db.Column(db.String, nullable=False)
    time = db.Column(db.Integer, nullable=False)
    description = db.Column(db.String, nullable=False)
    publicity = db.Column(db.String, nullable=False)
    tag = db.relationship("Tag", secondary=association_table_3, back_populates="event")
    creator = db.relationship("User", secondary=association_table_1, back_populates="event_created")
    attender = db.relationship("User", secondary=association_table_2, back_populates="event_interested")

    def __init__(self, **kwargs):
        self.title = kwargs.get("title", "") #string, a field to fill in title
        self.location = kwargs.get("location", "") #string, a field to fill in location
        self.time = kwargs.get("time", "") #long string contain date and time, slide buttons for date and time on app
        self.description = kwargs.get("description", "") #string, a field to fill in description
        self.publicity = kwargs.get("publicity", "") #string, multiple choice:"show to all", "show only to friends", "show only to group of friends"

    def serialize(self):
        return{
            "id": self.id,
            "title": self.title,
            "location": self.location,
            "time": self.time,
            "description": self.description,
            "publicity": self.publicity,
            "tag": [s.serialize() for s in self.tag],
            "creator": [s.serialize_for_event() for s in self.creator],
            "attender": [s.serialize_for_event() for s in self.attender]
        }


class Tag(db.Model):
    __tablename__ = "tag"
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    event = db.relationship("Event", secondary=association_table_3, back_populates="tag")
    
    def __init__(self, **kwargs):
        self.title = kwargs.get("title", "") # this is a field that we update limited tags
    
    def serialize(self):
        return{
            "id": self.id,
            "title": self.title,
        }


class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    social_account = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    event_created = db.relationship("Event", secondary=association_table_1, back_populates="creator")
    event_interested = db.relationship("Event", secondary=association_table_2, back_populates="attender")
    sent_request = db.relationship("Friend_request", secondary=association_table_4, back_populates="sender")
    received_request = db.relationship("Friend_request", secondary=association_table_5, back_populates="receiver")
    friend = db.relationship("Friend", secondary=association_table_6, back_populates="me")
    x = 0

    def __init__(self, **kwargs):
        self.name = kwargs.get("name", "") #string
        self.netid = kwargs.get("netid", "") #string
        self.password = kwargs.get("password", "") #string
        self.social_account = kwargs.get("social_account", "") #string
    
    
    def serialize(self): 
        event_created = []
        event_interested =[]
        
        if(self.event_created is not None):
            event_created = [i.serialize() for i in self.event_created]
        
        if(self.event_interested is not None):
            event_interested = [i.serialize() for i in self.event_interested]

        
        return{
            "id": self.id,
            "name": self.name,
            "netid": self.netid,
            "social_account": self.social_account,
            "event_created": event_created,
            "event_interested": event_interested,
            "friend": [s.serialize() for s in self.friend]
        }

    def serialize_for_event(self):
        return{
            "id": self.id,
            "name": self.name,
            "netid": self.netid,
            "social_account": self.social_account
            }
      

class Friend_request(db.Model):
    __tablename__ = "friend_request"
    id = db.Column(db.Integer, primary_key=True)
    sender_netid = db.Column(db.Integer, nullable=False)
    receiver_netid = db.Column(db.Integer, nullable=False)
    sender = db.relationship("User", secondary=association_table_4, back_populates="sent_request")
    receiver = db.relationship("User", secondary=association_table_5, back_populates="received_request")
    accepted = db.Column(db.String)
    
    def __init__(self, **kwargs):
        self.sender_netid = kwargs.get("sender_netid", "") # string, sender"s id
        self.receiver_netid = kwargs.get("receiver_netid", "") # string, receiver"s id
        self.accepted = kwargs.get("accepted", "")

    def serialize(self):
        return{
            "id": self.id,
            "sender_netid": self.sender_netid,
            "receiver_netid": self.receiver_netid,
            "accepted": self.accepted
        }
    

class Friend(db.Model):
    __tablename__ = "friend"
    id = db.Column(db.Integer, primary_key=True)
    me = db.relationship("User", secondary=association_table_6, back_populates="friend")
    me_netid = db.Column(db.String, nullable=False)
    friend_netid = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        self.me_netid = kwargs.get("me_netid", "")
        self.friend_netid = kwargs.get("friend_netid", "")
    
    def serialize(self):
        return{
            "id": self.id,
            "me_netid": self.me_netid,
            "friend_netid": self.friend_netid
        }

class Asset(db.Model):
    __tablename__ = "asset"

    id = db.Column(db.Integer, primary_key = True)
    base_url = db.Column(db.String, nullable=True)
    salt = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    width = db.Column(db.Integer, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    created_at= db.Column(db.DateTime, nullable=False)

    def __init__(self, **kwargs):
        self.create(kwargs.get("image_data"))
    
    def serialize(self):
        return{
            "url":f"{self.base_url}/{self.salt}.{self.extension}",
            "created_at": str(self.created_at),
        } 
    
    def create(self, image_data):
        try:
            #base64 string(image_data) plug in guess_type returns
            #--> .png --> [1:]strip of the first char: the period
            ext = guess_extension(guess_type(image_data)[0])[1:]
            if ext not in EXTENSIONS:
                raise Exception(f"Extension {e} not supported!")
            
            #secure way of generating random string for image name 
            salt = "".join(
                random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
                )
                for _ in range(16)         
            )
            
            #remove header of base64 string and open image
            img_str = re.sub("^data:image/.+;base64,", "", image_data)
            #replace this part ^data:image/.+;base64 in image_data with ""
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL
            self.salt = salt
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.created_at = datetime.datetime.now()
            img_filename = f"{salt}.{ext}" 
            self.upload(img, img_filename)
        except Exception as e:
            print(f"unable to create image due to {e}")
        
    
    def upload(self, img, img_filename):
        try:
            #save iamge temporarily on server
            img_temploc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temploc) #save image at this location
            print("Here")
            #upload iamge to S3
            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temploc, S3_BUCKET, img_filename)
            print("Here2")
            
            #make S3 image url public
            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET, img_filename)
            object_acl.put(ACL="public-read")
            print("Here3")

            os.remove(img_temploc)

        except Exception as e:
            print(f"unable to create image due to {e}")
