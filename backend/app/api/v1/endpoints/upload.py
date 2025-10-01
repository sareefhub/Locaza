from fastapi import APIRouter, UploadFile, File
from fastapi.responses import JSONResponse
from app.services.upload_service import UploadService

router = APIRouter(prefix="/upload", tags=["Upload"])

@router.post("/avatar/")
async def upload_avatar(file: UploadFile = File(...)):
    file_url = await UploadService.save_avatar(file)
    return {"avatar_url": file_url}

@router.post("/product/")
async def upload_product(file: UploadFile = File(...)):
    file_url = await UploadService.save_product(file)
    return {"image_url": file_url}

@router.post("/chat/{chatroom_id}")
async def upload_chat_image(chatroom_id: int, file: UploadFile = File(...)):
    file_url = await UploadService.save_chat_image(chatroom_id, file)
    return {"image_url": file_url}
