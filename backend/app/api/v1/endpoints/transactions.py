from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.db.session import get_db
from app.schemas.transaction_schema import (
    SaleTransactionCreate, SaleTransactionResponse,
    ReviewCreate, ReviewResponse
)
from app.services.transaction_service import SaleTransactionService, ReviewService

router = APIRouter(tags=["Transactions & Reviews"])

sale_router = APIRouter(prefix="/sale_transactions", tags=["SaleTransactions"])
review_router = APIRouter(prefix="/reviews", tags=["Reviews"])

@sale_router.post("/", response_model=SaleTransactionResponse)
def create_transaction(transaction: SaleTransactionCreate, db: Session = Depends(get_db)):
    return SaleTransactionService.create_transaction(db, transaction)

@sale_router.get("/", response_model=List[SaleTransactionResponse])
def list_transactions(db: Session = Depends(get_db)):
    return SaleTransactionService.list_transactions(db)

@sale_router.get("/{transaction_id}", response_model=SaleTransactionResponse)
def get_transaction(transaction_id: int, db: Session = Depends(get_db)):
    return SaleTransactionService.get_transaction(db, transaction_id)


@review_router.post("/", response_model=ReviewResponse)
def create_review(review: ReviewCreate, db: Session = Depends(get_db)):
    return ReviewService.create_review(db, review)

@review_router.get("/", response_model=List[ReviewResponse])
def list_reviews(db: Session = Depends(get_db)):
    return ReviewService.list_reviews(db)

@review_router.get("/{review_id}", response_model=ReviewResponse)
def get_review(review_id: int, db: Session = Depends(get_db)):
    return ReviewService.get_review(db, review_id)
