import os
from datetime import datetime, timezone
from fastapi import UploadFile, HTTPException

UPLOAD_DIR_AVATAR = "uploads/avatars"
UPLOAD_DIR_PRODUCT = "uploads/products"
UPLOAD_DIR_CHAT = "uploads/chat"

os.makedirs(UPLOAD_DIR_AVATAR, exist_ok=True)
os.makedirs(UPLOAD_DIR_PRODUCT, exist_ok=True)
os.makedirs(UPLOAD_DIR_CHAT, exist_ok=True)

class UploadService:
    MAX_FILE_SIZE = 5 * 1024 * 1024
    DEFAULT_AVATAR = "/uploads/avatars/default.png"

    @staticmethod
    async def save_avatar(file: UploadFile) -> str:
        return await UploadService._save_file(file, UPLOAD_DIR_AVATAR, prefix="avatar")

    @staticmethod
    async def save_product(file: UploadFile) -> str:
        return await UploadService._save_file(file, UPLOAD_DIR_PRODUCT, prefix="product")

    @staticmethod
    async def save_chat_image(chatroom_id: int, file: UploadFile) -> str:
        folder = os.path.join(UPLOAD_DIR_CHAT, str(chatroom_id))
        os.makedirs(folder, exist_ok=True)
        return await UploadService._save_file(file, folder, prefix=f"chat_{chatroom_id}")

    @staticmethod
    async def _save_file(file: UploadFile, folder: str, prefix: str = "file") -> str:
        if not file.content_type.startswith("image/"):
            raise HTTPException(status_code=400, detail="Only image files allowed")
        contents = await file.read()
        if len(contents) > UploadService.MAX_FILE_SIZE:
            raise HTTPException(status_code=400, detail="File too large (max 5MB)")
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S%f")
        ext = os.path.splitext(file.filename)[1] or ".png"
        filename = f"{prefix}_{timestamp}{ext}"
        file_path = os.path.join(folder, filename)
        os.makedirs(folder, exist_ok=True)
        with open(file_path, "wb") as f:
            f.write(contents)
        return f"/{file_path.replace(os.sep, '/')}"

    @staticmethod
    def delete_file(file_url: str):
        if not file_url or file_url == UploadService.DEFAULT_AVATAR:
            return
        file_path = file_url.lstrip("/")
        if os.path.exists(file_path):
            os.remove(file_path)
