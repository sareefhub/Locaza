from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

class UserBase(BaseModel):
    username: str
    name: str
    email: EmailStr
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    location: Optional[str] = None

class UserCreate(UserBase):
    password: str
    avatar_url: Optional[str] = None

class UserUpdate(BaseModel):
    username: Optional[str] = None
    name: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None
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

class UserOut(BaseModel):
    id: int
    username: Optional[str] = None
    name: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    location: Optional[str] = None
    is_verified: Optional[bool] = None
    reputation_score: Optional[float] = None
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True
