from sqlalchemy.orm import Session
from app.models.models import User
from app.schemas.user_schema import UserCreate, UserUpdate
from datetime import datetime

DEFAULT_AVATAR = "http://localhost:8000/uploads/avatars/default.png"

class UserService:
    @staticmethod
    def create_user(db: Session, user: UserCreate):
        avatar_url = user.avatar_url or DEFAULT_AVATAR
        db_user = User(
            name=user.name,
            email=user.email,
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
        for key, value in user.dict(exclude_unset=True).items():
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
        db.delete(db_user)
        db.commit()
        return db_user
