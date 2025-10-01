from pydantic import BaseModel
from datetime import datetime

class WishlistBase(BaseModel):
    user_id: int
    name: str

class WishlistCreate(WishlistBase):
    pass

class WishlistUpdate(WishlistBase):
    pass

class WishlistResponse(WishlistBase):
    id: int
    created_at: datetime | None = None

    class Config:
        from_attributes = True
