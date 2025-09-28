from sqlalchemy.orm import Session
from app.schemas.transaction_schema import SaleTransactionCreate, ReviewCreate
from app.repositories.transaction_repository import SaleTransactionRepository, ReviewRepository

class SaleTransactionService:
    @staticmethod
    def create_transaction(db: Session, transaction: SaleTransactionCreate):
        return SaleTransactionRepository.create(db, transaction)

    @staticmethod
    def get_transaction(db: Session, transaction_id: int):
        return SaleTransactionRepository.get(db, transaction_id)

    @staticmethod
    def list_transactions(db: Session, skip: int = 0, limit: int = 100):
        return SaleTransactionRepository.get_all(db, skip, limit)

    @staticmethod
    def get_purchases_by_user(db: Session, user_id: int):
        purchases = SaleTransactionRepository.get_purchases_by_user(db, user_id)
        return [
            {
                "id": p.id,
                "status": p.status,
                "created_at": p.created_at,
                "product_id": p.product_id,
                "product_title": p.product_title,
                "price": p.price,
                "image_url": (p.image_urls[0] if p.image_urls else None),
                "seller_id": p.seller_id,
                "seller_name": p.seller_name,
            }
            for p in purchases
        ]

class ReviewService:
    @staticmethod
    def create_review(db: Session, review: ReviewCreate):
        return ReviewRepository.create(db, review)

    @staticmethod
    def get_review(db: Session, review_id: int):
        return ReviewRepository.get(db, review_id)

    @staticmethod
    def list_reviews(db: Session, skip: int = 0, limit: int = 100):
        return ReviewRepository.get_all(db, skip, limit)
