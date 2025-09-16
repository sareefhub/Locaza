from pydantic import BaseModel
from datetime import datetime

class FavoriteBase(BaseModel):
    user_id: int
    product_id: int

class FavoriteCreate(FavoriteBase):
    pass

class FavoriteUpdate(FavoriteBase):
    pass

class FavoriteResponse(FavoriteBase):
    id: int
    created_at: datetime | None = None

    class Config:
        from_attributes = True
