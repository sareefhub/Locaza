from sqlalchemy.orm import Session, aliased
from sqlalchemy import desc
from app.models.models import Chatroom, Message, User, Product
from app.schemas.chat_schema import ChatroomCreate, MessageCreate

class ChatRepository:
    @staticmethod
    def create_chatroom(db: Session, chatroom: ChatroomCreate):
        existing = db.query(Chatroom).filter(
            Chatroom.buyer_id == chatroom.buyer_id,
            Chatroom.seller_id == chatroom.seller_id,
            Chatroom.product_id == chatroom.product_id
        ).first()
        if existing:
            return existing
        db_chatroom = Chatroom(**chatroom.dict())
        db.add(db_chatroom)
        db.commit()
        db.refresh(db_chatroom)
        return db_chatroom

    @staticmethod
    def get_chatroom_with_users(db: Session, chatroom_id: int):
        Buyer = aliased(User)
        Seller = aliased(User)
        row = (
            db.query(
                Chatroom.id,
                Chatroom.buyer_id,
                Buyer.name.label("buyer_name"),
                Chatroom.seller_id,
                Seller.name.label("seller_name"),
                Chatroom.product_id,
                Chatroom.created_at,
                Product.title.label("product_title"),
                Product.image_urls.label("product_images"),
                Product.price.label("product_price"),
                Product.status.label("product_status"),
            )
            .join(Buyer, Buyer.id == Chatroom.buyer_id)
            .join(Seller, Seller.id == Chatroom.seller_id)
            .join(Product, Product.id == Chatroom.product_id)
            .filter(Chatroom.id == chatroom_id)
            .first()
        )
        last_msg = (
            db.query(Message)
            .filter(Message.chatroom_id == chatroom_id)
            .order_by(desc(Message.created_at))
            .first()
        )
        return row, last_msg

    @staticmethod
    def list_chatrooms(db: Session):
        Buyer = aliased(User)
        Seller = aliased(User)
        rows = (
            db.query(
                Chatroom.id,
                Chatroom.buyer_id,
                Buyer.name.label("buyer_name"),
                Chatroom.seller_id,
                Seller.name.label("seller_name"),
                Chatroom.product_id,
                Chatroom.created_at,
                Product.title.label("product_title"),
                Product.image_urls.label("product_images"),
                Product.price.label("product_price"),
                Product.status.label("product_status"),
            )
            .join(Buyer, Buyer.id == Chatroom.buyer_id)
            .join(Seller, Seller.id == Chatroom.seller_id)
            .join(Product, Product.id == Chatroom.product_id)
            .all()
        )
        result = []
        for row in rows:
            last_msg = (
                db.query(Message)
                .filter(Message.chatroom_id == row.id)
                .order_by(desc(Message.created_at))
                .first()
            )
            result.append((row, last_msg))
        return result

    @staticmethod
    def create_message(db: Session, message: MessageCreate):
        db_message = Message(**message.dict())
        db.add(db_message)
        db.commit()
        db.refresh(db_message)
        return db_message

    @staticmethod
    def list_all_messages(db: Session):
        return db.query(Message).all()

    @staticmethod
    def list_messages(db: Session, chatroom_id: int):
        return db.query(Message).filter(Message.chatroom_id == chatroom_id).all()
