from sqlalchemy.orm import Session
from app.models.models import Notification
from app.schemas.notification_schema import NotificationCreate

class NotificationRepository:
    @staticmethod
    def create(db: Session, notification: NotificationCreate):
        db_notification = Notification(**notification.dict())
        db.add(db_notification)
        db.commit()
        db.refresh(db_notification)
        return db_notification

    @staticmethod
    def get(db: Session, notification_id: int):
        return db.query(Notification).filter(Notification.id == notification_id).first()

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        return db.query(Notification).offset(skip).limit(limit).all()
