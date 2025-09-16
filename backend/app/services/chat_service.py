from sqlalchemy.orm import Session
from app.repositories.chat_repository import ChatRepository
from app.schemas.chat_schema import ChatroomCreate, MessageCreate

class ChatService:
    @staticmethod
    def create_chatroom(db: Session, chatroom: ChatroomCreate):
        return ChatRepository.create_chatroom(db, chatroom)

    @staticmethod
    def list_chatrooms(db: Session):
        return ChatRepository.list_chatrooms(db)

    @staticmethod
    def create_message(db: Session, message: MessageCreate):
        return ChatRepository.create_message(db, message)

    @staticmethod
    def list_all_messages(db: Session):
        return ChatRepository.list_all_messages(db)

    @staticmethod
    def list_messages(db: Session, chatroom_id: int):
        return ChatRepository.list_messages(db, chatroom_id)
