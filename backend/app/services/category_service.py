from sqlalchemy.orm import Session
from app.schemas.category_schema import CategoryCreate, CategoryUpdate
from app.repositories.category_repository import CategoryRepository

class CategoryService:
    @staticmethod
    def create_category(db: Session, category: CategoryCreate):
        return CategoryRepository.create(db, category)

    @staticmethod
    def get_category(db: Session, category_id: int):
        return CategoryRepository.get(db, category_id)

    @staticmethod
    def list_categories(db: Session, skip: int = 0, limit: int = 100):
        return CategoryRepository.get_all(db, skip, limit)

    @staticmethod
    def update_category(db: Session, category_id: int, category: CategoryUpdate):
        return CategoryRepository.update(db, category_id, category)

    @staticmethod
    def delete_category(db: Session, category_id: int):
        return CategoryRepository.delete(db, category_id)
