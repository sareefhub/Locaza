from fastapi import FastAPI
from app.db.base import Base
from app.db.session import engine
from app.api.v1.endpoints import users, products

app = FastAPI(title="Locaza API", version="1.0.0")

Base.metadata.create_all(bind=engine)

app.include_router(users.router)
app.include_router(products.router)

@app.get("/")
def health_check():
    return {"message": "Locaza backend is running"}
