from sqlalchemy.orm import Session
from app.models.models import SaleTransaction, Review, Product, User
from app.schemas.transaction_schema import SaleTransactionCreate, ReviewCreate

class SaleTransactionRepository:
    @staticmethod
    def create(db: Session, transaction: SaleTransactionCreate):
        db_tx = SaleTransaction(**transaction.dict())
        db.add(db_tx)
        db.commit()
        db.refresh(db_tx)
        return db_tx

    @staticmethod
    def get(db: Session, transaction_id: int):
        return db.query(SaleTransaction).filter(SaleTransaction.id == transaction_id).first()

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        return db.query(SaleTransaction).offset(skip).limit(limit).all()

    @staticmethod
    def get_purchases_by_user(db: Session, user_id: int):
        return (
            db.query(
                SaleTransaction.id,
                SaleTransaction.status,
                SaleTransaction.created_at,
                Product.id.label("product_id"),
                Product.title.label("product_title"),
                Product.price,
                Product.image_urls,
                User.id.label("seller_id"),
                User.name.label("seller_name"),
            )
            .join(Product, Product.id == SaleTransaction.product_id)
            .join(User, User.id == SaleTransaction.seller_id)
            .filter(SaleTransaction.buyer_id == user_id)
            .all()
        )

class ReviewRepository:
    @staticmethod
    def create(db: Session, review: ReviewCreate):
        db_review = Review(**review.dict())
        db.add(db_review)
        db.commit()
        db.refresh(db_review)
        return db_review

    @staticmethod
    def get(db: Session, review_id: int):
        return db.query(Review).filter(Review.id == review_id).first()

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        return db.query(Review).offset(skip).limit(limit).all()

    @staticmethod
    def get_by_seller(db: Session, seller_id: int, skip: int = 0, limit: int = 100):
        return (
            db.query(Review)
            .filter(Review.reviewee_id == seller_id)
            .offset(skip)
            .limit(limit)
            .all()
        )
