from pydantic import BaseModel, EmailStr
from datetime import datetime

class UsernameRegisterRequest(BaseModel):
    username: str
    name: str
    email: EmailStr
    password: str
    phone: str | None = None
    location: str | None = None
    avatar_url: str | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None

class LoginRequest(BaseModel):
    username: str
    password: str

class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
