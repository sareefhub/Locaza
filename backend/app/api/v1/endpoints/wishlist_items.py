from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.schemas.wishlist_item_schema import WishlistItemCreate, WishlistItemResponse
from app.services.wishlist_item_service import WishlistItemService

router = APIRouter(prefix="/wishlist_items", tags=["Wishlist Items"])

@router.post("/", response_model=WishlistItemResponse)
def create_wishlist_item(wishlist_item: WishlistItemCreate, db: Session = Depends(get_db)):
    return WishlistItemService.create_wishlist_item(db, wishlist_item)

@router.get("/", response_model=list[WishlistItemResponse])
def list_wishlist_items(db: Session = Depends(get_db)):
    return WishlistItemService.list_wishlist_items(db)

@router.get("/{item_id}", response_model=WishlistItemResponse)
def get_wishlist_item(item_id: int, db: Session = Depends(get_db)):
    return WishlistItemService.get_wishlist_item(db, item_id)

@router.delete("/{item_id}")
def delete_wishlist_item(item_id: int, db: Session = Depends(get_db)):
    return WishlistItemService.delete_wishlist_item(db, item_id)
