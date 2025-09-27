import os
from datetime import datetime
from fastapi import UploadFile, HTTPException

UPLOAD_DIR_AVATAR = "uploads/avatars"
UPLOAD_DIR_PRODUCT = "uploads/products"
os.makedirs(UPLOAD_DIR_AVATAR, exist_ok=True)
os.makedirs(UPLOAD_DIR_PRODUCT, exist_ok=True)

class UploadService:
    MAX_FILE_SIZE = 5 * 1024 * 1024
    DEFAULT_AVATAR = "/uploads/avatars/default.png"

    @staticmethod
    async def save_avatar(file: UploadFile) -> str:
        if not file.content_type.startswith("image/"):
            raise HTTPException(status_code=400, detail="Only image files allowed")
        contents = await file.read()
        if len(contents) > UploadService.MAX_FILE_SIZE:
            raise HTTPException(status_code=400, detail="File too large (max 5MB)")
        timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S%f")
        filename = f"{timestamp}_{file.filename.replace(' ', '_')}"
        file_path = os.path.join(UPLOAD_DIR_AVATAR, filename)
        with open(file_path, "wb") as f:
            f.write(contents)
        return f"/{UPLOAD_DIR_AVATAR}/{filename}"

    @staticmethod
    async def save_product(file: UploadFile) -> str:
        if not file.content_type.startswith("image/"):
            raise HTTPException(status_code=400, detail="Only image files allowed")
        contents = await file.read()
        if len(contents) > UploadService.MAX_FILE_SIZE:
            raise HTTPException(status_code=400, detail="File too large (max 5MB)")
        timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S%f")
        filename = f"{timestamp}_{file.filename.replace(' ', '_')}"
        file_path = os.path.join(UPLOAD_DIR_PRODUCT, filename)
        with open(file_path, "wb") as f:
            f.write(contents)
        return f"/{UPLOAD_DIR_PRODUCT}/{filename}"

    @staticmethod
    def delete_file(file_url: str):
        if not file_url or file_url == UploadService.DEFAULT_AVATAR:
            return
        file_path = file_url.lstrip("/")
        if os.path.exists(file_path):
            os.remove(file_path)
