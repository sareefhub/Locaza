from pydantic import BaseModel

class PhoneRegisterRequest(BaseModel):
    phone: str

class PhoneVerifyRequest(BaseModel):
    phone: str
    otp: str

class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
