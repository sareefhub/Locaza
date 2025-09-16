from fastapi import FastAPI
from app.db.base import Base
from app.db.session import engine
from app.api.v1.endpoints import api_router

app = FastAPI(title="Locaza API", version="1.0.0")

Base.metadata.create_all(bind=engine)

app.include_router(api_router, prefix="/api/v1")

@app.get("/")
def health_check():
    return {"message": "Locaza backend is running"}
