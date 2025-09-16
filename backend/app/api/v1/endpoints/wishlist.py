from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.schemas.wishlist_schema import WishlistCreate, WishlistResponse
from app.services.wishlist_service import WishlistService

router = APIRouter(prefix="/wishlist", tags=["Wishlist"])

@router.post("/", response_model=WishlistResponse)
def create_wishlist(wishlist: WishlistCreate, db: Session = Depends(get_db)):
    return WishlistService.create_wishlist(db, wishlist)

@router.get("/", response_model=list[WishlistResponse])
def list_wishlists(db: Session = Depends(get_db)):
    return WishlistService.list_wishlists(db)

@router.get("/{wishlist_id}", response_model=WishlistResponse)
def get_wishlist(wishlist_id: int, db: Session = Depends(get_db)):
    return WishlistService.get_wishlist(db, wishlist_id)

@router.delete("/{wishlist_id}")
def delete_wishlist(wishlist_id: int, db: Session = Depends(get_db)):
    return WishlistService.delete_wishlist(db, wishlist_id)
