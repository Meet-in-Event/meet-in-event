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


# your classes here
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
        self.title = kwargs.get('title', '')
        self.location = kwargs.get('location', '')
        self.time = kwargs.get('time', '')
        self.description = kwargs.get('description', '')
        self.publicity = kwargs.get('publicity', '')

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
    event_created = db.relationship('Event', secondary=association_table_1, back_populates='creator')
    event_interested = db.relationship('Event', secondary=association_table_2, back_populates='attender')
    x = 0

    def __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.netid = kwargs.get('netid', '')
    
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

    class Friend(db.Model):
        __tablename__ = 'friend'
        id = db.Column(db.Integer, primary_key=True)
        sender_id = db.Column(db.String, nullable=False)
        receiver_id = db.Column(db.String, nullable=False)
        catagory = db.Column(db.String)
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
