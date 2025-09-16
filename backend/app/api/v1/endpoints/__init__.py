from fastapi import APIRouter
from app.api.v1.endpoints import (
    users,
    products,
    categories,
    favorites,
    wishlist,
    wishlist_items,
)

api_router = APIRouter()

api_router.include_router(users.router)
api_router.include_router(products.router)
api_router.include_router(categories.router)
api_router.include_router(favorites.router)
api_router.include_router(wishlist.router)
api_router.include_router(wishlist_items.router)
