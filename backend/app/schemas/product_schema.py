from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum

class ProductStatus(str, Enum):
    draft = "draft"
    available = "available"
    reserved = "reserved"
    purchased = "purchased"
    reviewed = "reviewed"
    sold = "sold"

class ProductBase(BaseModel):
    seller_id: int
    title: str
    description: Optional[str] = None
    price: float
    category_id: int
    location: Optional[str] = None
    status: ProductStatus = ProductStatus.available
    image_urls: list[str] = []

class ProductCreate(ProductBase):
    pass

class ProductUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    category_id: Optional[int] = None
    location: Optional[str] = None
    status: Optional[ProductStatus] = None
    image_urls: Optional[list[str]] = None

class ProductResponse(ProductBase):
    id: int
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True
