from sqlalchemy.orm import Session
from typing import List
from app.models.models import Category
from app.schemas.category_schema import CategoryCreate, CategoryUpdate

class CategoryRepository:
    @staticmethod
    def create(db: Session, category: CategoryCreate):
        db_category = Category(**category.dict())
        db.add(db_category)
        db.commit()
        db.refresh(db_category)
        return db_category

    @staticmethod
    def create_bulk(db: Session, categories: List[CategoryCreate]):
        db_categories = [Category(**c.dict()) for c in categories]
        db.add_all(db_categories)
        db.commit()
        for c in db_categories:
            db.refresh(c)
        return db_categories

    @staticmethod
    def get(db: Session, category_id: int):
        return db.query(Category).filter(Category.id == category_id).first()

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        return db.query(Category).offset(skip).limit(limit).all()

    @staticmethod
    def update(db: Session, category_id: int, category: CategoryUpdate):
        db_category = db.query(Category).filter(Category.id == category_id).first()
        if db_category:
            for key, value in category.dict(exclude_unset=True).items():
                setattr(db_category, key, value)
            db.commit()
            db.refresh(db_category)
        return db_category

    @staticmethod
    def delete(db: Session, category_id: int):
        db_category = db.query(Category).filter(Category.id == category_id).first()
        if db_category:
            db.delete(db_category)
            db.commit()
        return db_category
