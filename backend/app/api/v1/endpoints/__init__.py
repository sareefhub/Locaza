from fastapi import APIRouter
from app.api.v1.endpoints import (
    auth,
    users,
    products,
    categories,
    favorites,
    wishlist,
    wishlist_items,
    search_history,
    chats,
    transactions,
    notifications,
)

api_router = APIRouter()

api_router.include_router(auth.router)
api_router.include_router(users.router)
api_router.include_router(products.router)
api_router.include_router(categories.router)
api_router.include_router(favorites.router)
api_router.include_router(wishlist.router)
api_router.include_router(wishlist_items.router)
api_router.include_router(search_history.router)
api_router.include_router(chats.router)
api_router.include_router(transactions.sale_router)
api_router.include_router(transactions.review_router)
api_router.include_router(notifications.router)
