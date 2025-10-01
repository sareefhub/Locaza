from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class ProductBase(BaseModel):
    id: int
    title: str
    price: float
    description: Optional[str]
    image_urls: Optional[str]
    location: Optional[str]
    category_id: Optional[int]

    class Config:
        from_attributes = True

class FavoriteBase(BaseModel):
    user_id: int
    product_id: int

class FavoriteCreate(FavoriteBase):
    pass

class FavoriteUpdate(FavoriteBase):
    pass

class FavoriteResponse(FavoriteBase):
    id: int
    created_at: Optional[datetime] = None
    product: Optional[ProductBase] = None

    class Config:
        from_attributes = True
