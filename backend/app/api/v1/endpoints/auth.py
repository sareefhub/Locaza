from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from fastapi.security import HTTPAuthorizationCredentials
from app.db.session import get_db
from app.schemas.auth_schema import PhoneRegisterRequest, PhoneVerifyRequest, AuthResponse
from app.services.auth_service import AuthService
from app.core import security
from app.models.models import User
from app.schemas.user_schema import UserOut

router = APIRouter(prefix="/auth", tags=["Auth"])

@router.post("/register/phone")
def register_phone(request: PhoneRegisterRequest, db: Session = Depends(get_db)):
    return AuthService.register_phone(db, request)

@router.post("/verify/phone", response_model=AuthResponse)
def verify_phone(request: PhoneVerifyRequest, db: Session = Depends(get_db)):
    return AuthService.verify_phone(db, request)

@router.get("/me", response_model=UserOut)
def read_current_user(token: HTTPAuthorizationCredentials = Depends(security.oauth2_scheme), db: Session = Depends(get_db)):
    payload = security.decode_token(token.credentials)
    if not payload:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")
    user_id = payload.get("sub")
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
