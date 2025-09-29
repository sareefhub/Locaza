from sqlalchemy.orm import Session
from app.schemas.notification_schema import NotificationCreate
from app.repositories.notification_repository import NotificationRepository

class NotificationService:
    @staticmethod
    def create_notification(db: Session, notification: NotificationCreate):
        return NotificationRepository.create(db, notification)

    @staticmethod
    def get_notification(db: Session, notification_id: int):
        return NotificationRepository.get(db, notification_id)

    @staticmethod
    def list_notifications(db: Session, skip: int = 0, limit: int = 100):
        return NotificationRepository.get_all(db, skip, limit)

    @staticmethod
    def get_user_notifications(db: Session, user_id: int, skip: int = 0, limit: int = 100):
        return NotificationRepository.get_by_user(db, user_id, skip, limit)

    @staticmethod
    def mark_as_read(db: Session, notification_id: int):
        return NotificationRepository.mark_as_read(db, notification_id)
