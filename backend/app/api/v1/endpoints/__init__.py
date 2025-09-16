from fastapi import APIRouter
from app.api.v1.endpoints import users, products, categories

api_router = APIRouter()

api_router.include_router(users.router)
api_router.include_router(products.router)
api_router.include_router(categories.router)
