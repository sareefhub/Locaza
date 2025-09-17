from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.repositories.auth_repository import AuthRepository
from app.schemas.auth_schema import PhoneRegisterRequest, PhoneVerifyRequest
from app.core.security import create_access_token

class AuthService:
    @staticmethod
    def register_phone(db: Session, request: PhoneRegisterRequest):
        user = AuthRepository.get_user_by_phone(db, request.phone)
        if user:
            raise HTTPException(status_code=400, detail="Phone already registered")
        user = AuthRepository.create_user_with_phone(db, request.phone)
        return {"message": "OTP sent (mock: 1234)", "phone": user.phone}

    @staticmethod
    def verify_phone(db: Session, request: PhoneVerifyRequest):
        if request.otp != "1234":
            raise HTTPException(status_code=400, detail="Invalid OTP")
        user = AuthRepository.get_user_by_phone(db, request.phone)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        access_token = create_access_token(data={"sub": str(user.id)})
        return {"access_token": access_token, "token_type": "bearer"}
