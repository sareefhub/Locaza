from fastapi import APIRouter, UploadFile, File
from fastapi.responses import JSONResponse
from app.services.upload_service import UploadService

router = APIRouter(prefix="/upload", tags=["Upload"])

@router.post("/avatar/")
async def upload_avatar(file: UploadFile = File(...)):
    file_url = await UploadService.save_avatar(file)
    return JSONResponse(content={"avatar_url": file_url})
