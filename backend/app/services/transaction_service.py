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
