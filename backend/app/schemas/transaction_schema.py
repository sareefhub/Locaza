from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class SaleTransactionBase(BaseModel):
    product_id: int
    buyer_id: int
    seller_id: int
    chatroom_id: int
    status: str

class SaleTransactionCreate(SaleTransactionBase):
    pass

class SaleTransactionResponse(SaleTransactionBase):
    id: int
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


class ReviewBase(BaseModel):
    sale_transaction_id: int
    product_id: int
    reviewer_id: int
    reviewee_id: int
    rating: int
    comment: Optional[str] = None

class ReviewCreate(ReviewBase):
    pass

class ReviewResponse(ReviewBase):
    id: int
    created_at: Optional[datetime]

    class Config:
        from_attributes = True
