from sqlalchemy.orm import Session
from app.schemas.wishlist_item_schema import WishlistItemCreate, WishlistItemUpdate
from app.repositories.wishlist_item_repository import WishlistItemRepository

class WishlistItemService:
    @staticmethod
    def create_wishlist_item(db: Session, wishlist_item: WishlistItemCreate):
        return WishlistItemRepository.create(db, wishlist_item)

    @staticmethod
    def get_wishlist_item(db: Session, item_id: int):
        return WishlistItemRepository.get(db, item_id)

    @staticmethod
    def list_wishlist_items(db: Session, skip: int = 0, limit: int = 100):
        return WishlistItemRepository.get_all(db, skip, limit)

    @staticmethod
    def update_wishlist_item(db: Session, item_id: int, wishlist_item: WishlistItemUpdate):
        return WishlistItemRepository.update(db, item_id, wishlist_item)

    @staticmethod
    def delete_wishlist_item(db: Session, item_id: int):
        return WishlistItemRepository.delete(db, item_id)
