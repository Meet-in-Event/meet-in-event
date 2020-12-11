from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

association_table_1 = db.Table(
    'association1',
    db.Model.metadata,
    db.Column('event_id', db.Integer, db.ForeignKey('event.id')),
    db.Column('user_id', db.Integer, db.ForeignKey('user.id'))
)

association_table_2 = db.Table(
    'association2',
    db.Model.metadata,
    db.Column('event_id', db.Integer, db.ForeignKey('event.id')),
    db.Column('user_id', db.Integer, db.ForeignKey('user.id'))
)

association_table_3 = db.Table(
    'association3',
    db.Model.metadata,
    db.Column('event_id', db.Integer, db.ForeignKey('event.id')),
    db.Column('tag_id', db.Integer, db.ForeignKey('tag.id'))
)

association_table_4 = db.Table(
    'association4',
    db.Model.metadata,
    db.Column('request_id', db.Integer, db.ForeignKey('friend.id')),
    db.Column('sender_id', db.Integer, db.ForeignKey('user.id'))
)

association_table_5 = db.Table(
    'association5',
    db.Model.metadata,
    db.Column('request_id', db.Integer, db.ForeignKey('friend.id')),
    db.Column('receiver_id', db.Integer, db.ForeignKey('user.id'))
)


class Event(db.Model):
    __tablename__ = 'event'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    location = db.Column(db.String, nullable=False)
    time = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    publicity = db.Column(db.String, nullable=False)
    tag = db.relationship('Tag', secondary=association_table_3, back_populates='event')
    creator = db.relationship('User', secondary=association_table_1, back_populates='event_created')
    attender = db.relationship('User', secondary=association_table_2, back_populates='event_interested')

    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '') #string, a field to fill in title
        self.location = kwargs.get('location', '') #string, a field to fill in location
        self.time = kwargs.get('time', '') #long string contain date and time, slide buttons for date and time on app
        self.description = kwargs.get('description', '') #string, a field to fill in description
        self.publicity = kwargs.get('publicity', '') #string, multiple choice:'show to all', 'show only to friends', 'show only to group of friends'

    def serialize(self):
        return{
            'id': self.id,
            'title': self.title,
            'location': self.location,
            'time': self.time,
            'description': self.description,
            'publicity': self.publicity,
            'tag': [s.serialize() for s in self.tag],
            'creator': [s.serialize() for s in self.creator],
            'attendor': [s.serialize() for s in self.attendor]
        }


class Tag(db.Model):
    __tablename__ = 'tag'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    event = db.relationship('Event', secondary=association_table_3, back_populates='tag')
    
    def __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
    
    def serialize(self):
        return{
            'id': self.id,
            'title': self.title,
        }


class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    social_account = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    event_created = db.relationship('Event', secondary=association_table_1, back_populates='creator')
    event_interested = db.relationship('Event', secondary=association_table_2, back_populates='attender')
    sent_request = db.relationship('Friend_request', secondary=association_table_4, back_populates='sender_id') #only successfully accepted shows
    received_request = db.relationship('Friend_request', secondary=association_table_5, back_populates='receiver_id') #only successfully accepted shows
    x = 0

    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.netid = kwargs.get('netid', '')
        self.password = kwargs.get('password', '')
        self.social_account = kwargs.get('social_account', '')
    
    
    def serialize(self): 
        event_created = []
        event_interested = []
        for i in self.event_created:
            event_created += {
                'id': i.id,
                'title': i.title,
                'location': i.location,
                'time': i.time,
                'description': i.description,
                'tag': i.tag
            }
        for i in self.event_interested:
            event_interested += {
                'id': i.id,
                'title': i.title,
                'location': i.location,
                'time': i.time,
                'description': i.description,
                'tag': i.tag
            }
        return{
            'id': self.id,
            'name': self.name,
            'netid': self.netid,
            'event_created': event_created,
            'event_interested': event_interested
        }


    class Friend_request(db.Model):
        __tablename__ = 'friend_request'
        id = db.Column(db.Integer, primary_key=True)
        sender_id = db.relationship('User', secondary=association_table_4, back_populates='sent_request')
        receiver_id = db.relationship('User', secondary=association_table_5, back_populates='received_request')
        sender_catagory = db.Column(db.String, nullable=False) #sender set receiver
        receiver_catagory = db.Column(db.String, nullable=False) #receiver set sender
        accepted = db.Column(db.String)
    
    def __init__(self, **kwargs):
        self.sender_id = kwargs.get('sender_id', '')
        self.receiver_id = kwargs.get('receiver_id', '')

    def serialize(self):
        return{
            'id': self.id,
            'sender_id': self.sender_id,
            'receiver_id': self.receiver_id,
            'catagory': self.catagory,
            'accepted': self.accepted
        }
