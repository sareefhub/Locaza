from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class ChatroomBase(BaseModel):
    buyer_id: int
    seller_id: int
    product_id: int


class ChatroomCreate(ChatroomBase):
    pass


class ChatroomResponse(ChatroomBase):
    id: int
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


class MessageBase(BaseModel):
    chatroom_id: int
    sender_id: int
    content: str
    message_type: Optional[str] = "text"
    is_read: Optional[bool] = False


class MessageCreate(MessageBase):
    pass


class MessageResponse(MessageBase):
    id: int
    created_at: Optional[datetime]

    class Config:
        from_attributes = True
