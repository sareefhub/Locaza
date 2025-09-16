from sqlalchemy.orm import Session
from app.models.models import Favorite
from app.schemas.favorite_schema import FavoriteCreate, FavoriteUpdate

class FavoriteRepository:
    @staticmethod
    def create(db: Session, favorite: FavoriteCreate):
        db_fav = Favorite(**favorite.dict())
        db.add(db_fav)
        db.commit()
        db.refresh(db_fav)
        return db_fav

    @staticmethod
    def get(db: Session, favorite_id: int):
        return db.query(Favorite).filter(Favorite.id == favorite_id).first()

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        return db.query(Favorite).offset(skip).limit(limit).all()

    @staticmethod
    def update(db: Session, favorite_id: int, favorite: FavoriteUpdate):
        db_fav = db.query(Favorite).filter(Favorite.id == favorite_id).first()
        if not db_fav:
            return None
        for field, value in favorite.dict(exclude_unset=True).items():
            setattr(db_fav, field, value)
        db.commit()
        db.refresh(db_fav)
        return db_fav

    @staticmethod
    def delete(db: Session, favorite_id: int):
        db_fav = db.query(Favorite).filter(Favorite.id == favorite_id).first()
        if not db_fav:
            return None
        db.delete(db_fav)
        db.commit()
        return db_fav
