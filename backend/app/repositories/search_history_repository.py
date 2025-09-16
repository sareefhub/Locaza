from sqlalchemy.orm import Session
from app.models.models import SearchHistory
from app.schemas.search_history_schema import SearchHistoryCreate

class SearchHistoryRepository:
    @staticmethod
    def create(db: Session, history: SearchHistoryCreate):
        db_history = SearchHistory(**history.dict())
        db.add(db_history)
        db.commit()
        db.refresh(db_history)
        return db_history

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100):
        return db.query(SearchHistory).offset(skip).limit(limit).all()

    @staticmethod
    def get(db: Session, history_id: int):
        return db.query(SearchHistory).filter(SearchHistory.id == history_id).first()

    @staticmethod
    def delete(db: Session, history_id: int):
        db_history = db.query(SearchHistory).filter(SearchHistory.id == history_id).first()
        if not db_history:
            return None
        db.delete(db_history)
        db.commit()
        return db_history
