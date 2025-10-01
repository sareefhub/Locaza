from sqlalchemy.orm import Session
from sqlalchemy import select
from app.models.models import Notification, Product
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
        stmt = (
            select(Notification, Product)
            .join(Product, Notification.product_id == Product.id, isouter=True)
            .where(Notification.id == notification_id)
        )
        result = db.execute(stmt).first()
        if not result:
            return None
        notif, product = result
        return {
            "id": notif.id,
            "user_id": notif.user_id,
            "type": notif.type,
            "content": notif.content,
            "is_read": notif.is_read,
            "created_at": notif.created_at,
            "product_id": notif.product_id,
            "product": {
                "id": product.id,
                "title": product.title,
                "price": product.price,
                "description": product.description,
                "image_urls": product.image_urls,
                "location": product.location,
                "category_id": product.category_id,
            } if product else None
        }

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        stmt = (
            select(Notification, Product)
            .join(Product, Notification.product_id == Product.id, isouter=True)
            .offset(skip).limit(limit)
            .order_by(Notification.created_at.desc())
        )
        results = db.execute(stmt).all()
        notifications = []
        for notif, product in results:
            notifications.append({
                "id": notif.id,
                "user_id": notif.user_id,
                "type": notif.type,
                "content": notif.content,
                "is_read": notif.is_read,
                "created_at": notif.created_at,
                "product_id": notif.product_id,
                "product": {
                    "id": product.id,
                    "title": product.title,
                    "price": product.price,
                    "description": product.description,
                    "image_urls": product.image_urls,
                    "location": product.location,
                    "category_id": product.category_id,
                } if product else None
            })
        return notifications

    @staticmethod
    def get_by_user(db: Session, user_id: int, skip: int = 0, limit: int = 100):
        stmt = (
            select(Notification, Product)
            .join(Product, Notification.product_id == Product.id, isouter=True)
            .where(Notification.user_id == user_id)
            .offset(skip).limit(limit)
            .order_by(Notification.created_at.desc())
        )
        results = db.execute(stmt).all()
        notifications = []
        for notif, product in results:
            notifications.append({
                "id": notif.id,
                "user_id": notif.user_id,
                "type": notif.type,
                "content": notif.content,
                "is_read": notif.is_read,
                "created_at": notif.created_at,
                "product_id": notif.product_id,
                "product": {
                    "id": product.id,
                    "title": product.title,
                    "price": product.price,
                    "description": product.description,
                    "image_urls": product.image_urls,
                    "location": product.location,
                    "category_id": product.category_id,
                } if product else None
            })
        return notifications

    @staticmethod
    def mark_as_read(db: Session, notification_id: int):
        notif = db.query(Notification).filter(Notification.id == notification_id).first()
        if notif:
            notif.is_read = True
            db.commit()
            db.refresh(notif)
        return notif

    @staticmethod
    def delete(db: Session, notification_id: int):
        notif = db.query(Notification).filter(Notification.id == notification_id).first()
        if notif:
            db.delete(notif)
            db.commit()
            return notif
        return None
