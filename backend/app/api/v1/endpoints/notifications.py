from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.db.session import get_db
from app.schemas.notification_schema import NotificationCreate, NotificationResponse
from app.services.notification_service import NotificationService

router = APIRouter(prefix="/notifications", tags=["Notifications"])

@router.post("/", response_model=NotificationResponse)
def create_notification(notification: NotificationCreate, db: Session = Depends(get_db)):
    return NotificationService.create_notification(db, notification)

@router.get("/", response_model=List[NotificationResponse])
def list_notifications(db: Session = Depends(get_db)):
    return NotificationService.list_notifications(db)

@router.get("/{notification_id}", response_model=NotificationResponse)
def get_notification(notification_id: int, db: Session = Depends(get_db)):
    return NotificationService.get_notification(db, notification_id)
