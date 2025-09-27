from sqlalchemy.orm import Session
from app.schemas.product_schema import ProductCreate, ProductUpdate
from app.repositories.product_repository import ProductRepository
from app.services.upload_service import UploadService

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
    def get_products_by_user(db: Session, user_id: int):
        return ProductRepository.get_by_user(db, user_id)

    @staticmethod
    def update_product(db: Session, product_id: int, product: ProductUpdate):
        old_product = ProductRepository.get(db, product_id)
        if not old_product:
            return None
        updated_product = ProductRepository.update(db, product_id, product)
        old_images = set(old_product.get("image_urls") or [])
        new_images = set(updated_product.get("image_urls") or [])
        unused_images = old_images - new_images
        for img in unused_images:
            UploadService.delete_file(img)
        return updated_product

    @staticmethod
    def delete_product(db: Session, product_id: int):
        product = ProductRepository.get(db, product_id)
        if not product:
            return None
        for img in product.get("image_urls") or []:
            UploadService.delete_file(img)
        return ProductRepository.delete(db, product_id)
