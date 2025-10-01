from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class SearchHistoryBase(BaseModel):
    user_id: int
    query: str
    filters: Optional[str] = None

class SearchHistoryCreate(SearchHistoryBase):
    pass

class SearchHistoryResponse(SearchHistoryBase):
    id: int
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True
