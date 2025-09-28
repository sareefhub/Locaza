from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class ChatroomBase(BaseModel):
    buyer_id: int
    seller_id: int
    product_id: int

class ChatroomCreate(ChatroomBase):
    pass

class ChatroomResponse(ChatroomBase):
    id: int
    buyer_name: Optional[str]
    seller_name: Optional[str]
    created_at: Optional[datetime]
    last_message: Optional[str]
    last_message_time: Optional[datetime]
    product_title: Optional[str]
    product_images: Optional[List[str]]
    product_price: Optional[float]

    class Config:
        from_attributes = True

class MessageBase(BaseModel):
    chatroom_id: int
    sender_id: int
    content: Optional[str] = None
    message_type: Optional[str] = "text"
    image_urls: Optional[List[str]] = None
    is_read: Optional[bool] = False

class MessageCreate(MessageBase):
    pass

class MessageResponse(MessageBase):
    id: int
    created_at: Optional[datetime]

    class Config:
        from_attributes = True
