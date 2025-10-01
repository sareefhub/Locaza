from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.schemas.product_schema import ProductCreate, ProductUpdate, ProductResponse
from app.services.product_service import ProductService

router = APIRouter(prefix="/products", tags=["Products"])

@router.post("/", response_model=ProductResponse)
def create_product(product: ProductCreate, db: Session = Depends(get_db)):
    return ProductService.create_product(db, product)

@router.post("/bulk", response_model=list[ProductResponse])
def create_products(products: list[ProductCreate], db: Session = Depends(get_db)):
    return ProductService.create_products(db, products)

@router.get("/", response_model=list[ProductResponse])
def list_products(db: Session = Depends(get_db)):
    return ProductService.get_products(db)

@router.get("/{product_id}", response_model=ProductResponse)
def get_product(product_id: int, db: Session = Depends(get_db)):
    return ProductService.get_product(db, product_id)

@router.put("/{product_id}", response_model=ProductResponse)
def update_product(product_id: int, product: ProductUpdate, db: Session = Depends(get_db)):
    return ProductService.update_product(db, product_id, product)

@router.patch("/{product_id}/status", response_model=ProductResponse)
def update_product_status(product_id: int, product: ProductUpdate, db: Session = Depends(get_db)):
    return ProductService.update_product(db, product_id, product)

@router.delete("/{product_id}")
def delete_product(product_id: int, db: Session = Depends(get_db)):
    return ProductService.delete_product(db, product_id)
