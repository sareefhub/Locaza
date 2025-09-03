
# 🏗️ Backend Setup


```bash
mkdir backend
cd backend
```

## 2. สร้าง venv ด้วย Python 3.13

```bash
py -3.13 -m venv venv
```

## 3. Activate venv

```bash
.\venv\Scripts\activate.bat
```

## 4. เริ่มต้นโปรเจกต์ด้วย Poetry

```bash
poetry init --no-interaction
```

## 5. ตั้งค่าให้ Poetry เก็บ venv ในโฟลเดอร์โปรเจกต์

```bash
poetry config virtualenvs.in-project true
```

## 6. บอก Poetry ให้ใช้ Python ใน .venv

```bash
poetry env use venv\Scripts\python.exe
```

## 7. ติดตั้งไลบรารีหลัก

```bash
poetry add fastapi uvicorn python-jose passlib[bcrypt] pydantic
```

## 8. ติดตั้งไลบรารีสำหรับพัฒนา

```bash
poetry add --dev pytest httpx
```

## 9. ตรวจสอบ environment & แพ็กเกจ

```bash
poetry env info
poetry show
```

## 10. รันเซิร์ฟเวอร์ FastAPI (ถ้า entrypoint ชื่อ main.py)

```bash
poetry run uvicorn app.main:app --reload
```