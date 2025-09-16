from sqlalchemy.orm import Session
from app.models.models import Wishlist
from app.schemas.wishlist_schema import WishlistCreate, WishlistUpdate

class WishlistRepository:
    @staticmethod
    def create(db: Session, wishlist: WishlistCreate):
        db_wishlist = Wishlist(**wishlist.dict())
        db.add(db_wishlist)
        db.commit()
        db.refresh(db_wishlist)
        return db_wishlist

    @staticmethod
    def get(db: Session, wishlist_id: int):
        return db.query(Wishlist).filter(Wishlist.id == wishlist_id).first()

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        return db.query(Wishlist).offset(skip).limit(limit).all()

    @staticmethod
    def update(db: Session, wishlist_id: int, wishlist: WishlistUpdate):
        db_wishlist = db.query(Wishlist).filter(Wishlist.id == wishlist_id).first()
        if not db_wishlist:
            return None
        for field, value in wishlist.dict(exclude_unset=True).items():
            setattr(db_wishlist, field, value)
        db.commit()
        db.refresh(db_wishlist)
        return db_wishlist

    @staticmethod
    def delete(db: Session, wishlist_id: int):
        db_wishlist = db.query(Wishlist).filter(Wishlist.id == wishlist_id).first()
        if not db_wishlist:
            return None
        db.delete(db_wishlist)
        db.commit()
        return db_wishlist
