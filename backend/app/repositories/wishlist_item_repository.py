from sqlalchemy.orm import Session
from app.models.models import WishlistItem
from app.schemas.wishlist_item_schema import WishlistItemCreate, WishlistItemUpdate

class WishlistItemRepository:
    @staticmethod
    def create(db: Session, wishlist_item: WishlistItemCreate):
        db_item = WishlistItem(**wishlist_item.dict())
        db.add(db_item)
        db.commit()
        db.refresh(db_item)
        return db_item

    @staticmethod
    def get(db: Session, item_id: int):
        return db.query(WishlistItem).filter(WishlistItem.id == item_id).first()

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        return db.query(WishlistItem).offset(skip).limit(limit).all()

    @staticmethod
    def update(db: Session, item_id: int, wishlist_item: WishlistItemUpdate):
        db_item = db.query(WishlistItem).filter(WishlistItem.id == item_id).first()
        if not db_item:
            return None
        for field, value in wishlist_item.dict(exclude_unset=True).items():
            setattr(db_item, field, value)
        db.commit()
        db.refresh(db_item)
        return db_item

    @staticmethod
    def delete(db: Session, item_id: int):
        db_item = db.query(WishlistItem).filter(WishlistItem.id == item_id).first()
        if not db_item:
            return None
        db.delete(db_item)
        db.commit()
        return db_item
