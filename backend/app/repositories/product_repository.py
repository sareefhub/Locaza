from sqlalchemy.orm import Session
from app.models.models import Product
from app.schemas.product_schema import ProductCreate, ProductUpdate


class ProductRepository:
    @staticmethod
    def create(db: Session, product: ProductCreate):
        db_product = Product(**product.dict())
        db.add(db_product)
        db.commit()
        db.refresh(db_product)
        return db_product

    @staticmethod
    def get(db: Session, product_id: int):
        return db.query(Product).filter(Product.id == product_id).first()

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 10):
        return db.query(Product).offset(skip).limit(limit).all()

    @staticmethod
    def update(db: Session, product_id: int, product: ProductUpdate):
        db_product = db.query(Product).filter(Product.id == product_id).first()
        if not db_product:
            return None
        for field, value in product.dict(exclude_unset=True).items():
            setattr(db_product, field, value)
        db.commit()
        db.refresh(db_product)
        return db_product

    @staticmethod
    def delete(db: Session, product_id: int):
        db_product = db.query(Product).filter(Product.id == product_id).first()
        if not db_product:
            return None
        db.delete(db_product)
        db.commit()
        return db_product
