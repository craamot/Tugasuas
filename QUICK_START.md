## 🚀 QUICK START - SQLite Login & Register

Panduan singkat untuk memulai dengan SQLite integration.

---

## 1️⃣ Setup (First Time)

### Step 1: Jalankan pub get
```bash
flutter pub get
```

### Step 2: Build & Run
```bash
flutter clean
flutter pub get
flutter run
```

---

## 2️⃣ File Structure

```
✅ SUDAH DIBUAT:

lib/
├── database/
│   └── db_helper.dart          ← Handle semua database operation
├── models/
│   └── user.dart               ← User data model
└── screens/
    ├── login_page.dart         ← Login screen (UPDATED)
    └── register_page.dart      ← Register screen (NEW)
```

---

## 3️⃣ Cara Pakai

### Register User:
```dart
// User buka app → klik "Daftar di sini"
// Isi form → klik "Daftar"
// ✅ Database menyimpan user baru
```

### Login User:
```dart
// User input email & password
// System cek di database
// ✅ Cocok → Masuk dashboard
// ❌ Tidak cocok → Tampil error
```

---

## 4️⃣ Database Details

**Nama Database:** `app.db`  
**Lokasi:** Aplikasi Documents Folder  
**Tabel:** `users`

**Kolom Tabel Users:**
```
┌─────────┬──────────┬──────────────────┐
│ Column  │ Type     │ Constraint       │
├─────────┼──────────┼──────────────────┤
│ id      │ INTEGER  │ PRIMARY KEY AUTO │
│ name    │ TEXT     │ NOT NULL         │
│ email   │ TEXT     │ UNIQUE NOT NULL  │
│ password│ TEXT     │ NOT NULL         │
└─────────┴──────────┴──────────────────┘
```

---

## 5️⃣ Testing Checklist

### ✅ Register:
- [ ] Buka Register page
- [ ] Isi nama, email, password, confirm password
- [ ] Klik Daftar → Harus berhasil dan kembali ke login
- [ ] Coba register dengan email sama → Harus error

### ✅ Login:
- [ ] Isi email & password yang sudah register
- [ ] Klik Login → Harus masuk dashboard
- [ ] Coba login dengan email/password salah → Harus error

### ✅ Validasi:
- [ ] Kosongkan field → Error message
- [ ] Email format salah → Error message
- [ ] Password < 6 karakter → Error message
- [ ] Password tidak match (register) → Error message

---

## 6️⃣ Main Functions Reference

### DatabaseHelper

| Function | Input | Output | Keterangan |
|----------|-------|--------|-----------|
| `registerUser()` | name, email, password | bool | Daftar user baru |
| `loginUser()` | email, password | User? | Verifikasi login |
| `isEmailExists()` | email | bool | Cek email ada/tidak |
| `getAllUsers()` | - | List<User> | Ambil semua user |
| `deleteAllUsers()` | - | void | Reset database |

### User Model

```dart
User(
  id: 1,                           // Auto dari database
  name: "Ahmad",                   // Input dari user
  email: "ahmad@email.com",        // Input dari user (unique)
  password: "hashed_password",     // Di-hash sebelum simpan
)
```

---

## 7️⃣ Common Issues & Solutions

### ❌ "Plugin not found"
→ Jalankan: `flutter pub get` dan rebuild

### ❌ "Database exception"
→ Jalankan: `flutter clean` dan `flutter run` lagi

### ❌ Login selalu gagal
→ Pastikan password benar dan tidak ada extra space
→ Gunakan `.trim()` untuk hapus space

### ❌ Email duplicate tidak terdeteksi
→ Itu fitur! Email adalah UNIQUE di database

### ❌ Mau reset database
→ Gunakan: `DatabaseHelper().deleteAllUsers();`

---

## 8️⃣ Next Steps (Feature Expansion)

Untuk development lebih lanjut, bisa tambah:

- [ ] **Remember Me** - Simpan login state dengan SharedPreferences
- [ ] **Logout** - Fungsi untuk logout user
- [ ] **Forgot Password** - Reset password via email
- [ ] **User Profile** - Lihat & edit user profile
- [ ] **Email Verification** - Verifikasi email saat register
- [ ] **Better Password Hashing** - Upgrade ke bcrypt
- [ ] **Session Management** - Auto-logout after timeout
- [ ] **Biometric Auth** - Login dengan fingerprint/face

---

## 9️⃣ Important Notes

1. **Password Hashing**: Menggunakan MD5 (simple untuk learning)
   - Untuk production, upgrade ke bcrypt/Argon2

2. **Database Instance**: Menggunakan Singleton pattern
   - Hanya ada 1 instance DatabaseHelper di seluruh app
   - Lebih efisien dan aman

3. **Validation**: Dilakukan di 2 tempat:
   - Client-side (form validation)
   - Server-side (database query)

4. **Error Handling**: Semua error ditangkap & ditampilkan ke user
   - SnackBar untuk feedback
   - Try-catch untuk exception handling

---

## 🔟 File Locations

```
📁 Project Root
├── lib/
│   ├── database/
│   │   └── db_helper.dart          ← Database operations
│   ├── models/
│   │   └── user.dart               ← User model
│   ├── screens/
│   │   ├── login_page.dart         ← Login screen
│   │   └── register_page.dart      ← Register screen
│   ├── examples/
│   │   └── database_examples.dart  ← Example usage
│   └── main.dart                   ← App entry point
├── pubspec.yaml                    ← Dependencies (UPDATED)
├── SQLITE_INTEGRATION.md           ← Full documentation
└── QUICK_START.md                  ← This file
```

---

## 📞 Support Resources

- Dokumentasi Lengkap: [SQLITE_INTEGRATION.md](SQLITE_INTEGRATION.md)
- Contoh Kode: [lib/examples/database_examples.dart](lib/examples/database_examples.dart)
- Flutter Docs: https://flutter.dev/docs
- sqflite Package: https://pub.dev/packages/sqflite

---

**Happy Coding! 🎉**

Jika ada pertanyaan, cek dokumentasi atau contoh kode yang sudah disediakan.
