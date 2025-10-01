from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class ProductBase(BaseModel):
    id: int
    title: str
    price: float
    description: Optional[str]
    image_urls: Optional[List[str]] = None
    location: Optional[str]
    category_id: Optional[int]

    class Config:
        from_attributes = True

class NotificationBase(BaseModel):
    user_id: int
    type: str
    content: str
    is_read: Optional[bool] = False
    product_id: Optional[int] = None

class NotificationCreate(NotificationBase):
    pass

class NotificationResponse(NotificationBase):
    id: int
    created_at: Optional[datetime]
    product: Optional[ProductBase] = None

    class Config:
        from_attributes = True
