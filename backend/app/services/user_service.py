from sqlalchemy.orm import Session
from app.models.models import User
from app.schemas.user_schema import UserCreate, UserUpdate
from datetime import datetime
from app.core.security import get_password_hash
from app.services.upload_service import UploadService

DEFAULT_AVATAR = "/uploads/avatars/default.png"

class UserService:
    @staticmethod
    def create_user(db: Session, user: UserCreate):
        avatar_url = user.avatar_url or DEFAULT_AVATAR
        hashed_password = get_password_hash(user.password)
        db_user = User(
            username=user.username,
            name=user.name,
            email=user.email,
            password=hashed_password,
            phone=user.phone,
            avatar_url=avatar_url,
            location=user.location,
            is_verified=False,
            reputation_score=0,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

    @staticmethod
    def get_user(db: Session, user_id: int):
        return db.query(User).filter(User.id == user_id).first()

    @staticmethod
    def get_users(db: Session, skip: int = 0, limit: int = 10):
        return db.query(User).offset(skip).limit(limit).all()

    @staticmethod
    def update_user(db: Session, user_id: int, user: UserUpdate):
        db_user = db.query(User).filter(User.id == user_id).first()
        if not db_user:
            return None

        update_data = user.dict(exclude_unset=True)

        if "password" in update_data:
            update_data["password"] = get_password_hash(update_data["password"])

        if "avatar_url" in update_data and update_data["avatar_url"] != db_user.avatar_url:
            UploadService.delete_file(db_user.avatar_url)

        for key, value in update_data.items():
            setattr(db_user, key, value)

        db_user.updated_at = datetime.utcnow()
        db.commit()
        db.refresh(db_user)
        return db_user

    @staticmethod
    def delete_user(db: Session, user_id: int):
        db_user = db.query(User).filter(User.id == user_id).first()
        if not db_user:
            return None

        if db_user.avatar_url and db_user.avatar_url != DEFAULT_AVATAR:
            UploadService.delete_file(db_user.avatar_url)

        db.delete(db_user)
        db.commit()
        return db_user
