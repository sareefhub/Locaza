from sqlalchemy.orm import Session
from app.models.models import User
from app.schemas.user_schema import UserCreate
from typing import List

class UserRepository:
    @staticmethod
    def create(db: Session, user: UserCreate) -> User:
        db_user = User(**user.dict())
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

    @staticmethod
    def bulk_create(db: Session, users: List[UserCreate]) -> List[User]:
        db_users = [User(**user.dict()) for user in users]
        db.add_all(db_users)
        db.commit()
        for u in db_users:
            db.refresh(u)
        return db_users

    @staticmethod
    def get_by_id(db: Session, user_id: int) -> User | None:
        return db.query(User).filter(User.id == user_id).first()
