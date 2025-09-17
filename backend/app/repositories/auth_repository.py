from sqlalchemy.orm import Session
from app.models.models import User

class AuthRepository:
    @staticmethod
    def get_user_by_phone(db: Session, phone: str):
        return db.query(User).filter(User.phone == phone).first()

    @staticmethod
    def create_user_with_phone(db: Session, phone: str):
        user = User(phone=phone, name=f"User_{phone[-4:]}")
        db.add(user)
        db.commit()
        db.refresh(user)
        return user
