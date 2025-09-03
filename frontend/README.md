
# 🏗️ Flutter Clean Architecture

## 📂 Project Structure

```
lib
├─ config/                          # เก็บการตั้งค่าและ configuration ของแอป เช่น environment, dependency injection, flavor
│   └── environment.dart            # ไฟล์เก็บค่า environment (เช่น dev, staging, production) เพื่อให้เลือก config ตามสภาพแวดล้อม
│
├─ core/                            # ส่วนกลางของแอปที่ใช้ร่วมกันได้ทุก feature
│   ├── errors/                     # จัดการ error/exception กลาง เช่น Failure class, AppException
│   ├── usecases/                   # คลาส UseCase ทั่วไป เช่น BaseUseCase<T, Params>
│   └── widgets/                    # Widget ที่สามารถนำกลับมาใช้ซ้ำได้ทั่วทั้งแอป เช่น CustomButton, CustomTextField
│
├─ features/                        # แบ่งตามฟีเจอร์ (แยกโค้ดชัดเจน ดูแลง่าย ขยายระบบได้สะดวก)
│   ├─ auth/                        # ฟีเจอร์ Authentication (Login, Register, Logout)
│   │   ├─ presentation/            # UI Layer → แสดงหน้าจอและ widgets
│   │   │   ├─ screens/             # โฟลเดอร์เก็บ screens ของ Auth
│   │   │   │   ├── login_screen.dart   # หน้าจอ login หลัก (Scaffold, AppBar, Body)
│   │   │   │   └── guest_screen.dart   # หน้าจอ guest (เข้าใช้งานแบบไม่ต้อง login)
│   │   │   │
│   │   │   ├─ widgets/             # เก็บ UI ย่อย ๆ ของ Auth
│   │   │   │   └── login_page.dart # ส่วนย่อยของ UI (เช่น ฟอร์ม login แยกออกมา)
│   │   │   │
│   │   │   └─ state/               # จัดการ state (provider, bloc, notifier)
│   │   │       ├── login_notifier.dart # StateNotifier/ViewModel → ใช้ Riverpod/Bloc จัดการ state
│   │   │       └── guest_notifier.dart # จัดการ state ของ guest
│   │   │
│   │   ├─ application/             # Application Layer → จัดการ state และประสานงานกับ UseCase
│   │   │   └── login_notifier.dart # StateNotifier/ViewModel → ใช้ Riverpod/Bloc จัดการ state (loading, success, error)
│   │   │
│   │   ├─ domain/                  # Domain Layer → Business logic ที่ไม่ขึ้นกับ Flutter หรือ Infrastructure
│   │   │   ├── entities/           # เก็บ entity หลัก เช่น User (pure Dart class)
│   │   │   │   └── user.dart       # Entity User → ตัวแทนข้อมูลในเชิง business logic
│   │   │   ├── repositories/       # Interface ของ Repository (abstract class)
│   │   │   │   └── auth_repository.dart  # สัญญา (contract) กำหนดว่าต้องมี login(), logout() โดยไม่สนใจว่าจะทำงานยังไง
│   │   │   └── usecases/           # กรณีการใช้งาน (UseCases) → ตรรกะเชิงธุรกิจ
│   │   │       └── login_usecase.dart   # LoginUseCase → เรียกใช้ repository เพื่อตรวจสอบ login
│   │   │
│   │   └─ infrastructure/          # Data Layer → จัดการข้อมูลจริง (API, DB, Cache)
│   │       ├── models/             # Data Model (API/DB) → ใช้สำหรับแปลง JSON ↔ Dart
│   │       │   └── user_model.dart # UserModel → ใช้แทน entity User เวลาติดต่อกับ API
│   │       ├── services/           # บริการภายนอก เช่น REST API, Firebase, Local DB
│   │       │   └── auth_api_service.dart # AuthApiService → จัดการ call API login, register
│   │       └── repositories_impl/  # Implement จริงของ repository ที่ใช้ Data Source
│   │           └── auth_repository_impl.dart # AuthRepositoryImpl → implements AuthRepository และใช้ AuthApiService ทำงาน
│   │
│   └─ profile/ ... (โครงสร้างคล้าย auth) # ฟีเจอร์อื่น ๆ เช่น Profile, Products, Cart ทำตาม pattern เดียวกัน
│
├─ routing/                         # การจัดการเส้นทาง (Route / Navigation)
│   └── app_router.dart             # ไฟล์รวม routes ของแอป เช่น GoRouter หรือ AutoRoute
│
├─ utils/                           # ฟังก์ชันช่วยเหลือทั่วไป (Utility functions)
│   └── validators.dart             # ตัวช่วยตรวจสอบข้อมูล เช่น validateEmail, validatePassword
│
├─ main.dart                        # entry point หลัก (Production) → runApp() แอปจริง
├─ main_staging.dart                # entry point สำหรับ staging → ใช้ config แยกต่างหาก
└─ main_development.dart            # entry point สำหรับ development → ใช้ dev config
```