from sqlalchemy.orm import Session
from app.models.models import Product
from app.schemas.product_schema import ProductCreate, ProductUpdate
import json

class ProductRepository:
    @staticmethod
    def create(db: Session, product: ProductCreate):
        data = product.dict()
        db_product = Product(**data)
        db.add(db_product)
        db.commit()
        db.refresh(db_product)
        return ProductRepository._to_dict(db_product)

    @staticmethod
    def create_bulk(db: Session, products: list[ProductCreate]):
        db_products = [Product(**p.dict()) for p in products]
        db.add_all(db_products)
        db.commit()
        for p in db_products:
            db.refresh(p)
        return [ProductRepository._to_dict(p) for p in db_products]

    @staticmethod
    def get(db: Session, product_id: int):
        product = db.query(Product).filter(Product.id == product_id).first()
        return ProductRepository._to_dict(product) if product else None

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 10):
        products = db.query(Product).offset(skip).limit(limit).all()
        return [ProductRepository._to_dict(p) for p in products]

    @staticmethod
    def get_by_user(db: Session, user_id: int):
        products = db.query(Product).filter(Product.seller_id == user_id).all()
        return [ProductRepository._to_dict(p) for p in products]

    @staticmethod
    def update(db: Session, product_id: int, product: ProductUpdate):
        db_product = db.query(Product).filter(Product.id == product_id).first()
        if not db_product:
            return None
        for field, value in product.dict(exclude_unset=True).items():
            setattr(db_product, field, value)
        db.commit()
        db.refresh(db_product)
        return ProductRepository._to_dict(db_product)

    @staticmethod
    def delete(db: Session, product_id: int):
        db_product = db.query(Product).filter(Product.id == product_id).first()
        if not db_product:
            return None
        db.delete(db_product)
        db.commit()
        return db_product

    @staticmethod
    def _to_dict(product: Product):
        if not product:
            return None
        return {
            "id": product.id,
            "seller_id": product.seller_id,
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "category_id": product.category_id,
            "location": product.location,
            "status": product.status,
            "image_urls": product.image_urls if isinstance(product.image_urls, list) else (
                json.loads(product.image_urls) if product.image_urls else []
            ),
            "created_at": product.created_at,
            "updated_at": product.updated_at,
        }
