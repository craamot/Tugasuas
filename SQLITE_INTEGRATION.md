## 📱 Dokumentasi Integrasi SQLite untuk Login & Register

Panduan lengkap untuk memahami implementasi SQLite di project Flutter Anda.

---

## 📁 Struktur File Baru

```
lib/
├── database/
│   └── db_helper.dart          ← Database helper (CRUD operations)
├── models/
│   └── user.dart               ← User model
└── screens/
    ├── login_page.dart         ← Updated login page dengan database
    └── register_page.dart      ← New register page dengan database
```

---

## 🔧 Dependencies yang Ditambahkan

```yaml
sqflite: ^2.4.1       # SQLite database untuk Flutter
path_provider: ^2.1.2 # Untuk akses file system
path: ^1.9.0          # Path utilities
crypto: ^3.0.3        # Untuk hash password
```

Jalankan: `flutter pub get`

---

## 📚 File-File Penting

### 1. **lib/models/user.dart**
Model User untuk representasi data pengguna

```dart
User(
  id: 1,
  name: "Ahmad Hendra",
  email: "ahmad@email.com",
  password: "hashed_password_here"
)
```

**Methods:**
- `toMap()` - Convert ke Map untuk database
- `fromMap()` - Convert dari Map database ke object

---

### 2. **lib/database/db_helper.dart**
Database Helper - Central point untuk semua operasi database

**Inisialisasi Database:**
- Membuat file `app.db` di aplikasi documents directory
- Membuat tabel `users` secara otomatis

**Tabel Users:**
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL
)
```

**Fungsi Utama:**

| Fungsi | Deskripsi |
|--------|-----------|
| `registerUser()` | Daftar user baru |
| `loginUser()` | Verifikasi login |
| `isEmailExists()` | Cek email sudah terdaftar |
| `getAllUsers()` | Ambil semua user (debug) |
| `deleteAllUsers()` | Hapus semua user (reset) |

---

### 3. **lib/screens/login_page.dart**
Halaman Login dengan validasi form dan database integration

**Features:**
- ✅ Email validation
- ✅ Password validation (min 6 karakter)
- ✅ Query database untuk verifikasi
- ✅ Loading state
- ✅ Error handling dengan SnackBar
- ✅ Navigate ke Register page
- ✅ Redirect ke Dashboard jika login berhasil

**Flow:**
1. User input email & password
2. Form validation
3. Hash password dengan MD5
4. Query database
5. Jika match → navigasi ke Dashboard
6. Jika tidak match → tampilkan error

---

### 4. **lib/screens/register_page.dart**
Halaman Register untuk membuat akun baru

**Features:**
- ✅ Input: Nama, Email, Password, Confirm Password
- ✅ Validasi form (nama min 3 char, email format, password min 6 char)
- ✅ Cek apakah email sudah terdaftar
- ✅ Hash password sebelum menyimpan
- ✅ Error handling
- ✅ Success message dengan redirect ke login

**Validasi:**
- Nama: minimal 3 karakter
- Email: format valid & unique
- Password: minimal 6 karakter
- Confirm Password: harus sama dengan password

---

## 🚀 Cara Kerja Alur Login & Register

### Register Flow:
```
Form Input
    ↓
Validasi Input
    ↓
Cek Email Exists
    ↓
Hash Password (MD5)
    ↓
Insert ke Database
    ↓
Success → Kembali ke Login
```

### Login Flow:
```
Form Input
    ↓
Validasi Input
    ↓
Hash Password (MD5)
    ↓
Query Database (email + password)
    ↓
User Found? 
├─ Yes → Navigate ke Dashboard
└─ No  → Show Error SnackBar
```

---

## 💾 Contoh Penggunaan DatabaseHelper

### Register User Baru:
```dart
DatabaseHelper db = DatabaseHelper();

bool isSuccess = await db.registerUser(
  name: "Budi Santoso",
  email: "budi@email.com",
  password: "password123",
);

if (isSuccess) {
  print("User registered successfully!");
} else {
  print("Email already exists!");
}
```

### Login User:
```dart
User? user = await db.loginUser(
  email: "budi@email.com",
  password: "password123",
);

if (user != null) {
  print("Login successful: ${user.name}");
  // Navigate to dashboard
} else {
  print("Invalid email or password");
}
```

### Cek Email Exists:
```dart
bool exists = await db.isEmailExists("budi@email.com");
```

---

## 🔐 Password Security

**Current Implementation:** MD5 Hashing
- ⚠️ Untuk development/learning purposes
- ⚠️ TIDAK aman untuk production

**Untuk Production, gunakan:**
- bcrypt
- Argon2
- PBKDF2
- Scrypt

**Update ke bcrypt:**
```dart
// Add to pubspec.yaml
bcrypt: ^1.1.3

// Usage
String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
bool isPasswordValid = BCrypt.checkpw(password, hashedPassword);
```

---

## 📋 Testing Manual

### Test Register:
1. Buka app
2. Klik "Daftar di sini"
3. Isi form (nama, email, password)
4. Klik "Daftar"
5. Verifikasi: ✅ Success message + kembali ke login

### Test Register Duplicate Email:
1. Register dengan email yang sama
2. Verifikasi: ❌ Error message "Email sudah terdaftar"

### Test Login Success:
1. Input email & password yang sudah register
2. Klik "Login"
3. Verifikasi: ✅ Success message + navigate ke dashboard

### Test Login Failed:
1. Input email/password yang salah
2. Klik "Login"
3. Verifikasi: ❌ Error message "Email atau password salah"

### Test Validation:
1. Input kosong → Error message
2. Email format invalid → Error message
3. Password < 6 char → Error message
4. Password tidak match → Error message

---

## 🛠️ Troubleshooting

### Error: "MissingPluginException"
**Solusi:** Jalankan `flutter pub get` dan build ulang

### Database tidak terupdate
**Solusi:** 
```bash
flutter clean
flutter pub get
flutter run
```

### Password tidak match padahal sama
**Solusi:** Pastikan input tidak ada space, gunakan `.trim()`

### Email tidak bisa duplicate
**Solusi:** Itu fitur! Email harus unique

---

## 📝 Catatan Penting

1. **Database Location**: `Documents/app.db`
   - Android: `/data/data/com.example.app/app_flutter`
   - iOS: `Documents/app.db`

2. **Singleton Pattern**: `DatabaseHelper` hanya ada 1 instance
   - Lebih efisien (1 database connection)
   - Thread-safe

3. **Password Hashing**: Menggunakan MD5 (simple untuk learning)
   - Upgrade ke bcrypt untuk production

4. **Form Validation**: Menggunakan `TextFormField` dengan validator
   - Setiap field punya validasi
   - Error message ditampilkan di bawah field

5. **State Management**: Menggunakan `StatefulWidget`
   - Untuk simple app ini sudah cukup
   - Untuk app besar, gunakan Provider/BLoC/Riverpod

---

## ✨ Fitur yang Bisa Ditambah

- [ ] Remember me (SharedPreferences)
- [ ] Forgot password
- [ ] Email verification
- [ ] Two-factor authentication
- [ ] User profile update
- [ ] Change password
- [ ] Logout functionality
- [ ] Session timeout
- [ ] Biometric authentication

---

## 📖 Referensi

- [Flutter SQLite Documentation](https://flutter.dev/docs/cookbook/persistence/sqlite)
- [sqflite Package](https://pub.dev/packages/sqflite)
- [Password Security Best Practices](https://owasp.org/www-community/attacks/Password_attacks)

---

**Last Updated:** 20 Jan 2026
**Version:** 1.0.0
