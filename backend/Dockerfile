# ใช้ Python 3.13 slim
FROM python:3.13-slim

# ตั้ง working directory
WORKDIR /app

# ติดตั้ง dependency พื้นฐาน
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl && \
    rm -rf /var/lib/apt/lists/*

# ติดตั้ง poetry
RUN pip install --no-cache-dir poetry

# ปิดการสร้าง virtualenv ใน poetry (ให้ใช้ global env)
RUN poetry config virtualenvs.create false

# คัดลอกไฟล์ dependency ก่อน (cache layer)
COPY pyproject.toml poetry.lock* ./

# ติดตั้ง dependencies
RUN poetry install --no-root --no-interaction --no-ansi

# คัดลอก source code
COPY . .

# เปิดพอร์ต FastAPI
EXPOSE 8000

# คำสั่งรัน uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
