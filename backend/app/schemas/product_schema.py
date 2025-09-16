from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ProductBase(BaseModel):
    seller_id: int
    title: str
    description: Optional[str] = None
    price: float
    category_id: int
    location: Optional[str] = None
    status: Optional[str] = "available"
    image_urls: Optional[str] = None

class ProductCreate(ProductBase):
    pass

class ProductUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    category_id: Optional[int] = None
    location: Optional[str] = None
    status: Optional[str] = None
    image_urls: Optional[str] = None

class ProductResponse(ProductBase):
    id: int
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True
