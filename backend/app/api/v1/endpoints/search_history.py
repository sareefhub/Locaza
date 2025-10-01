from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.schemas.search_history_schema import SearchHistoryCreate, SearchHistoryResponse
from app.services.search_history_service import SearchHistoryService

router = APIRouter(prefix="/search_history", tags=["Search History"])

@router.post("/", response_model=SearchHistoryResponse)
def create_search_history(history: SearchHistoryCreate, db: Session = Depends(get_db)):
    return SearchHistoryService.create_search_history(db, history)

@router.get("/", response_model=list[SearchHistoryResponse])
def list_search_history(db: Session = Depends(get_db)):
    return SearchHistoryService.list_search_history(db)

@router.get("/{history_id}", response_model=SearchHistoryResponse)
def get_search_history(history_id: int, db: Session = Depends(get_db)):
    return SearchHistoryService.get_search_history(db, history_id)

@router.delete("/{history_id}")
def delete_search_history(history_id: int, db: Session = Depends(get_db)):
    return SearchHistoryService.delete_search_history(db, history_id)
