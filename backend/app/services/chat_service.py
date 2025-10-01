from sqlalchemy.orm import Session
from app.repositories.chat_repository import ChatRepository
from app.schemas.chat_schema import ChatroomCreate, MessageCreate, ChatroomResponse, MessageResponse

class ChatService:
    @staticmethod
    def create_chatroom(db: Session, chatroom: ChatroomCreate):
        db_chatroom = ChatRepository.create_chatroom(db, chatroom)
        row, last_msg = ChatRepository.get_chatroom_with_users(db, db_chatroom.id)
        return ChatroomResponse(
            id=row.id,
            buyer_id=row.buyer_id,
            buyer_name=row.buyer_name,
            seller_id=row.seller_id,
            seller_name=row.seller_name,
            product_id=row.product_id,
            created_at=row.created_at,
            last_message=last_msg.content if last_msg else None,
            last_message_time=last_msg.created_at if last_msg else None,
            product_title=row.product_title,
            product_images=row.product_images,
            product_price=row.product_price,
            product_status=row.product_status,
        )

    @staticmethod
    def list_chatrooms(db: Session):
        rows = ChatRepository.list_chatrooms(db)
        return [
            ChatroomResponse(
                id=row.id,
                buyer_id=row.buyer_id,
                buyer_name=row.buyer_name,
                seller_id=row.seller_id,
                seller_name=row.seller_name,
                product_id=row.product_id,
                created_at=row.created_at,
                last_message=last_msg.content if last_msg else None,
                last_message_time=last_msg.created_at if last_msg else None,
                product_title=row.product_title,
                product_images=row.product_images,
                product_price=row.product_price,
                product_status=row.product_status,
            )
            for row, last_msg in rows
        ]

    @staticmethod
    def create_message(db: Session, message: MessageCreate):
        return ChatRepository.create_message(db, message)

    @staticmethod
    def list_all_messages(db: Session):
        rows = ChatRepository.list_all_messages(db)
        return [
            MessageResponse(
                id=row.id,
                chatroom_id=row.chatroom_id,
                sender_id=row.sender_id,
                content=row.content,
                message_type=row.message_type,
                image_urls=row.image_urls,
                created_at=row.created_at,
            )
            for row in rows
        ]

    @staticmethod
    def list_messages(db: Session, chatroom_id: int):
        rows = ChatRepository.list_messages(db, chatroom_id)
        return [
            MessageResponse(
                id=row.id,
                chatroom_id=row.chatroom_id,
                sender_id=row.sender_id,
                content=row.content,
                message_type=row.message_type,
                image_urls=row.image_urls,
                created_at=row.created_at,
            )
            for row in rows
        ]
