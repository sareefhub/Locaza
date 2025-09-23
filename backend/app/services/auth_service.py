from sqlalchemy.orm import Session
from fastapi import HTTPException
from datetime import datetime
from app.repositories.auth_repository import AuthRepository
from app.schemas.auth_schema import UsernameRegisterRequest, LoginRequest, AuthResponse
from app.core.security import create_access_token, verify_password, get_password_hash

DEFAULT_AVATAR = "http://localhost:8000/uploads/avatars/default.png"

class AuthService:
    @staticmethod
    def register_username(db: Session, request: UsernameRegisterRequest) -> AuthResponse:
        user = AuthRepository.get_user_by_username(db, request.username)
        if user:
            raise HTTPException(status_code=400, detail="Username already registered")

        user = AuthRepository.get_user_by_email(db, request.email)
        if user:
            raise HTTPException(status_code=400, detail="Email already registered")

        hashed_password = get_password_hash(request.password)
        avatar_url = request.avatar_url or DEFAULT_AVATAR

        new_user = AuthRepository.create_user_with_username(
            db,
            username=request.username,
            name=request.name,
            email=request.email,
            password=hashed_password,
            phone=request.phone,
            location=request.location,
            avatar_url=avatar_url,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow(),
        )

        access_token = create_access_token(data={"sub": str(new_user.id)})
        return AuthResponse(access_token=access_token)

    @staticmethod
    def login(db: Session, request: LoginRequest) -> AuthResponse:
        user = AuthRepository.get_user_by_username(db, request.username)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        if not verify_password(request.password, user.password):
            raise HTTPException(status_code=400, detail="Incorrect password")

        access_token = create_access_token(data={"sub": str(user.id)})
        return AuthResponse(access_token=access_token)
