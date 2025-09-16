from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class WishlistItemBase(BaseModel):
    wishlist_id: int
    product_id: int

class WishlistItemCreate(WishlistItemBase):
    pass

class WishlistItemUpdate(BaseModel):
    wishlist_id: Optional[int] = None
    product_id: Optional[int] = None

class WishlistItemResponse(WishlistItemBase):
    id: int
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True
