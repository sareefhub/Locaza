from sqlalchemy.orm import Session
from fastapi import HTTPException
from datetime import datetime
from app.repositories.auth_repository import AuthRepository
from app.schemas.auth_schema import UsernameRegisterRequest, LoginRequest, AuthResponse
from app.core.security import create_access_token, verify_password, get_password_hash

DEFAULT_AVATAR = "/uploads/avatars/default.png"


class AuthBase:
    @staticmethod
    def _register(
        db: Session,
        username: str,
        email: str,
        password: str,
        phone: str | None = None,
        avatar_url: str | None = None,
    ) -> AuthResponse:
        user = AuthRepository.get_user_by_username(db, username)
        if user:
            raise HTTPException(status_code=400, detail="Username already registered")

        user = AuthRepository.get_user_by_email(db, email)
        if user:
            raise HTTPException(status_code=400, detail="Email already registered")

        hashed_password = get_password_hash(password)
        avatar_url = avatar_url or DEFAULT_AVATAR

        new_user = AuthRepository.create_user_with_username(
            db,
            username=username,
            email=email,
            password=hashed_password,
            phone=phone,
            avatar_url=avatar_url,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow(),
        )

        access_token = create_access_token(data={"sub": str(new_user.id)})
        return AuthResponse(access_token=access_token)

    @staticmethod
    def _login(db: Session, username: str, password: str) -> AuthResponse:
        user = AuthRepository.get_user_by_username(db, username)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        if not verify_password(password, user.password):
            raise HTTPException(status_code=400, detail="Incorrect password")

        access_token = create_access_token(data={"sub": str(user.id)})
        return AuthResponse(access_token=access_token)


class AuthService(AuthBase):
    @staticmethod
    def register_username(db: Session, request: UsernameRegisterRequest) -> AuthResponse:
        return AuthBase._register(
            db,
            request.username,
            request.email,
            request.password,
            request.phone,
            request.avatar_url,
        )

    @staticmethod
    def login(db: Session, request: LoginRequest) -> AuthResponse:
        return AuthBase._login(db, request.username, request.password)


class AuthServiceLite(AuthBase):
    @staticmethod
    def register_username(db: Session, request: UsernameRegisterRequest) -> AuthResponse:
        return AuthBase._register(
            db,
            request.username,
            request.email,
            request.password,
            request.phone,
            request.avatar_url,
        )

    @staticmethod
    def login(db: Session, request: LoginRequest) -> AuthResponse:
        return AuthBase._login(db, request.username, request.password)
