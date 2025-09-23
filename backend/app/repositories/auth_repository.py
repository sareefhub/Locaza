from sqlalchemy.orm import Session
from app.models.models import User
from datetime import datetime


class AuthRepository:
    @staticmethod
    def get_user_by_username(db: Session, username: str):
        return db.query(User).filter(User.username == username).first()

    @staticmethod
    def get_user_by_email(db: Session, email: str):
        return db.query(User).filter(User.email == email).first()

    @staticmethod
    def create_user_with_username(
        db: Session,
        username: str,
        name: str,
        email: str,
        password: str,
        phone: str | None = None,
        location: str | None = None,
        avatar_url: str | None = None,
        created_at: datetime | None = None,
        updated_at: datetime | None = None,
    ):
        user = User(
            username=username,
            name=name,
            email=email,
            password=password,
            phone=phone,
            location=location,
            avatar_url=avatar_url,
            created_at=created_at or datetime.utcnow(),
            updated_at=updated_at or datetime.utcnow(),
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        return user
