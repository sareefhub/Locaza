from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.schemas.chat_schema import ChatroomCreate, ChatroomResponse, MessageCreate, MessageResponse
from app.services.chat_service import ChatService

router = APIRouter(tags=["Chats"])

@router.post("/chatrooms/", response_model=ChatroomResponse)
def create_chatroom(chatroom: ChatroomCreate, db: Session = Depends(get_db)):
    return ChatService.create_chatroom(db, chatroom)

@router.get("/chatrooms/", response_model=list[ChatroomResponse])
def list_chatrooms(db: Session = Depends(get_db)):
    return ChatService.list_chatrooms(db)

@router.post("/messages/", response_model=MessageResponse)
def create_message(message: MessageCreate, db: Session = Depends(get_db)):
    return ChatService.create_message(db, message)

@router.get("/messages/", response_model=list[MessageResponse])
def list_all_messages(db: Session = Depends(get_db)):
    return ChatService.list_all_messages(db)

@router.get("/messages/{chatroom_id}", response_model=list[MessageResponse])
def list_messages(chatroom_id: int, db: Session = Depends(get_db)):
    return ChatService.list_messages(db, chatroom_id)
