from sqlalchemy.orm import Session
from app.schemas.wishlist_schema import WishlistCreate, WishlistUpdate
from app.repositories.wishlist_repository import WishlistRepository

class WishlistService:
    @staticmethod
    def create_wishlist(db: Session, wishlist: WishlistCreate):
        return WishlistRepository.create(db, wishlist)

    @staticmethod
    def get_wishlist(db: Session, wishlist_id: int):
        return WishlistRepository.get(db, wishlist_id)

    @staticmethod
    def list_wishlists(db: Session, skip: int = 0, limit: int = 100):
        return WishlistRepository.get_all(db, skip, limit)

    @staticmethod
    def update_wishlist(db: Session, wishlist_id: int, wishlist: WishlistUpdate):
        return WishlistRepository.update(db, wishlist_id, wishlist)

    @staticmethod
    def delete_wishlist(db: Session, wishlist_id: int):
        return WishlistRepository.delete(db, wishlist_id)
