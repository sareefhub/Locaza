from sqlalchemy.orm import Session
from app.schemas.favorite_schema import FavoriteCreate, FavoriteUpdate
from app.repositories.favorite_repository import FavoriteRepository

class FavoriteService:
    @staticmethod
    def create_favorite(db: Session, favorite: FavoriteCreate):
        return FavoriteRepository.create(db, favorite)

    @staticmethod
    def get_favorite(db: Session, favorite_id: int):
        return FavoriteRepository.get(db, favorite_id)

    @staticmethod
    def list_favorites(db: Session, skip: int = 0, limit: int = 100):
        return FavoriteRepository.get_all(db, skip, limit)

    @staticmethod
    def get_user_favorites(db: Session, user_id: int):
        return FavoriteRepository.get_by_user(db, user_id)

    @staticmethod
    def update_favorite(db: Session, favorite_id: int, favorite: FavoriteUpdate):
        return FavoriteRepository.update(db, favorite_id, favorite)

    @staticmethod
    def delete_favorite(db: Session, favorite_id: int):
        return FavoriteRepository.delete(db, favorite_id)
