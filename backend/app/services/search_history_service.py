from sqlalchemy.orm import Session
from app.schemas.search_history_schema import SearchHistoryCreate
from app.repositories.search_history_repository import SearchHistoryRepository

class SearchHistoryService:
    @staticmethod
    def create_search_history(db: Session, history: SearchHistoryCreate):
        return SearchHistoryRepository.create(db, history)

    @staticmethod
    def list_search_history(db: Session, skip: int = 0, limit: int = 100):
        return SearchHistoryRepository.get_all(db, skip, limit)

    @staticmethod
    def get_search_history(db: Session, history_id: int):
        return SearchHistoryRepository.get(db, history_id)

    @staticmethod
    def delete_search_history(db: Session, history_id: int):
        return SearchHistoryRepository.delete(db, history_id)
