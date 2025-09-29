from sqlalchemy.orm import Session
from sqlalchemy import select
from app.models.models import Favorite, Product
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
    def get_by_user(db: Session, user_id: int):
        stmt = (
            select(Favorite, Product)
            .join(Product, Favorite.product_id == Product.id)
            .where(Favorite.user_id == user_id)
        )
        results = db.execute(stmt).all()
        favorites = []
        for fav, prod in results:
            favorites.append({
                "id": fav.id,
                "user_id": fav.user_id,
                "product_id": fav.product_id,
                "created_at": fav.created_at,
                "product": {
                    "id": prod.id,
                    "title": prod.title,
                    "price": prod.price,
                    "description": prod.description,
                    "image_urls": prod.image_urls,
                    "location": prod.location,
                    "category_id": prod.category_id,
                }
            })
        return favorites

    @staticmethod
    def get_by_product(db: Session, product_id: int):
        return db.query(Favorite).filter(Favorite.product_id == product_id).all()

    @staticmethod
    def get_users_by_category(db: Session, category_id: int):
        stmt = (
            select(Favorite.user_id)
            .join(Product, Favorite.product_id == Product.id)
            .where(Product.category_id == category_id)
            .distinct()
        )
        results = db.execute(stmt).scalars().all()
        return results

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
