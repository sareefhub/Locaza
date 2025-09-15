from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class UserBase(BaseModel):
    name: str
    email: str
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    location: Optional[str] = None


class UserCreate(UserBase):
    pass


class UserUpdate(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    location: Optional[str] = None
    is_verified: Optional[bool] = None


class UserResponse(UserBase):
    id: int
    is_verified: bool
    reputation_score: float
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True
