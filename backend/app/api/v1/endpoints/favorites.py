from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.schemas.favorite_schema import FavoriteCreate, FavoriteResponse
from app.services.favorite_service import FavoriteService

router = APIRouter(prefix="/favorites", tags=["Favorites"])

@router.post("/", response_model=FavoriteResponse)
def create_favorite(favorite: FavoriteCreate, db: Session = Depends(get_db)):
    return FavoriteService.create_favorite(db, favorite)

@router.get("/", response_model=list[FavoriteResponse])
def list_favorites(db: Session = Depends(get_db)):
    return FavoriteService.list_favorites(db)

@router.get("/{favorite_id}", response_model=FavoriteResponse)
def get_favorite(favorite_id: int, db: Session = Depends(get_db)):
    return FavoriteService.get_favorite(db, favorite_id)

@router.delete("/{favorite_id}")
def delete_favorite(favorite_id: int, db: Session = Depends(get_db)):
    return FavoriteService.delete_favorite(db, favorite_id)
