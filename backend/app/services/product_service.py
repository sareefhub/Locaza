from sqlalchemy.orm import Session
from app.schemas.product_schema import ProductCreate, ProductUpdate
from app.repositories.product_repository import ProductRepository

class ProductService:
    @staticmethod
    def create_product(db: Session, product: ProductCreate):
        return ProductRepository.create(db, product)

    @staticmethod
    def create_products(db: Session, products: list[ProductCreate]):
        return ProductRepository.create_bulk(db, products)

    @staticmethod
    def get_product(db: Session, product_id: int):
        return ProductRepository.get(db, product_id)

    @staticmethod
    def get_products(db: Session, skip: int = 0, limit: int = 10):
        return ProductRepository.get_all(db, skip, limit)

    @staticmethod
    def update_product(db: Session, product_id: int, product: ProductUpdate):
        return ProductRepository.update(db, product_id, product)

    @staticmethod
    def delete_product(db: Session, product_id: int):
        return ProductRepository.delete(db, product_id)
