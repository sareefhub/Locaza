from sqlalchemy.orm import Session
from app.repositories.product_repository import ProductRepository
from app.services.upload_service import UploadService
from app.services.notification_service import NotificationService
from app.repositories.favorite_repository import FavoriteRepository
from app.schemas.notification_schema import NotificationCreate

class ProductService:
    @staticmethod
    def create_product(db: Session, product):
        new_product = ProductRepository.create(db, product)
        favorites = FavoriteRepository.get_users_by_category(db, product.category_id)
        for user_id in favorites:
            NotificationService.create_notification(
                db,
                NotificationCreate(
                    user_id=user_id,
                    type="new_product",
                    content=new_product["title"],
                    product_id=new_product["id"]
                )
            )
        return new_product

    @staticmethod
    def create_products(db: Session, products):
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
    def update_product(db: Session, product_id: int, product):
        old_product = ProductRepository.get(db, product_id)
        if not old_product:
            return None
        updated_product = ProductRepository.update(db, product_id, product)
        if old_product.get("status") != "sold" and updated_product.get("status") == "sold":
            favorites = FavoriteRepository.get_by_product(db, product_id)
            for fav in favorites:
                NotificationService.create_notification(
                    db,
                    NotificationCreate(
                        user_id=fav.user_id,
                        type="product_sold",
                        content=updated_product["title"],
                        product_id=updated_product["id"]
                    )
                )
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
