from sqlalchemy.orm import Session
from app.models.models import Chatroom, Message
from app.schemas.chat_schema import ChatroomCreate, MessageCreate

class ChatRepository:
    @staticmethod
    def create_chatroom(db: Session, chatroom: ChatroomCreate):
        db_chatroom = Chatroom(**chatroom.dict())
        db.add(db_chatroom)
        db.commit()
        db.refresh(db_chatroom)
        return db_chatroom

    @staticmethod
    def list_chatrooms(db: Session):
        return db.query(Chatroom).all()

    @staticmethod
    def create_message(db: Session, message: MessageCreate):
        db_message = Message(**message.dict())
        db.add(db_message)
        db.commit()
        db.refresh(db_message)
        return db_message

    @staticmethod
    def list_all_messages(db: Session):
        return db.query(Message).all()

    @staticmethod
    def list_messages(db: Session, chatroom_id: int):
        return db.query(Message).filter(Message.chatroom_id == chatroom_id).all()
