# 🚀 CARA MENJALANKAN APLIKASI

Panduan lengkap untuk menjalankan aplikasi Flutter "Pengingat Jadwal Kuliah" dengan SQLite Login & Register.

---

## ⚡ QUICK START (Paling Mudah)

### Opsi 1: RUN DI WEB BROWSER (Chrome)
```bash
flutter clean
flutter pub get
flutter run -d chrome
```
✅ **Paling Mudah** - Otomatis buka Chrome  
✅ Tidak perlu device fisik  
✅ Testing cepat

---

### Opsi 2: RUN DI ANDROID
```bash
flutter clean
flutter pub get
flutter run
```
Pastikan:
- ✓ Android Emulator sudah buka, ATAU
- ✓ Android Device terhubung via USB

---

### Opsi 3: RUN DI WINDOWS DESKTOP
```bash
flutter clean
flutter pub get
flutter run -d windows
```
✅ Berjalan sebagai desktop app  

---

## 📋 SETUP PERTAMA KALI (WAJIB)

Ikuti langkah-langkah ini SEBELUM menjalankan app:

### 1. Buka Terminal/Command Prompt
- **Windows:** Tekan `Windows Key + R`, ketik `cmd`, tekan Enter
- **atau:** Klik kanan di folder → "Open PowerShell window here"

### 2. Masuk ke folder project
```bash
cd /path/to/latihan4_navigasi
```

### 3. Clean project
```bash
flutter clean
```

### 4. Install dependencies
```bash
flutter pub get
```

### 5. Verifikasi setup
```bash
flutter doctor
```

---

## 🎯 OPSI RUN LENGKAP

### A. ANDROID (Device atau Emulator)

#### Setup:
1. Buka **Android Studio**
2. Buka **Android Emulator** atau hubungkan device via USB
3. Verifikasi device terdaftar:
   ```bash
   flutter devices
   ```

#### Command untuk run:
```bash
# Auto (rekomendasi)
flutter run

# Release mode (lebih cepat)
flutter run --release

# Specific device
flutter run -d <device_id>
```

**Contoh output:**
```
Multiple devices found:
1. emulator-5554 (Android 12)
2. FA92N1A01234   (Android 11 - Physical Device)

Please choose one (to skip this prompt, pass the --device flag).
```

---

### B. WEB (Chrome, Firefox, Safari)

#### Chrome:
```bash
flutter run -d chrome
```

#### Firefox:
```bash
flutter run -d firefox
```

#### Safari (macOS only):
```bash
flutter run -d safari
```

#### Release mode:
```bash
flutter run -d chrome --release
```

**Keuntungan WEB:**
- ✅ Tidak perlu install di device
- ✅ Cepat untuk testing
- ✅ Bisa access dari browser manapun

---

### C. iOS (macOS only)

#### Setup:
1. Pastikan di **macOS**
2. Buka **iOS Simulator**
3. Update Cocoapods:
   ```bash
   sudo gem install cocoapods
   cd ios
   pod install
   cd ..
   ```

#### Command untuk run:
```bash
# Auto
flutter run

# Release
flutter run --release
```

---

### D. WINDOWS DESKTOP

#### Setup:
1. Install **Visual Studio** atau **Visual Studio Build Tools**
2. Verifikasi:
   ```bash
   flutter doctor
   ```

#### Command untuk run:
```bash
# Debug
flutter run -d windows

# Release
flutter run -d windows --release
```

---

### E. LINUX DESKTOP

#### Setup:
1. Install Linux build dependencies:
   ```bash
   sudo apt-get install clang cmake git pkg-config libgtk-3-dev
   ```

#### Command untuk run:
```bash
# Debug
flutter run -d linux

# Release
flutter run -d linux --release
```

---

## 🔥 PERINTAH BERGUNA

### List semua device yang tersedia
```bash
flutter devices
```

### Lihat Flutter info
```bash
flutter --version
```

### Diagnostik lengkap
```bash
flutter doctor -v
```

### Build APK untuk Android
```bash
flutter build apk
```

### Build web
```bash
flutter build web
```

---

## ⚠️ TROUBLESHOOTING

### Problem 1: "Plugin not found"
**Solusi:**
```bash
flutter clean
flutter pub get
flutter run
```

### Problem 2: "No connected devices"
**Solusi:**
- Buka Android Emulator terlebih dahulu, ATAU
- Hubungkan device USB, ATAU
- Gunakan WEB: `flutter run -d chrome`

### Problem 3: "Permission denied" di macOS/Linux
**Solusi:**
```bash
chmod +x RUN_GUIDE.sh
./RUN_GUIDE.sh
```

### Problem 4: Compilation error
**Solusi:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

### Problem 5: Database error (tidak bisa login/register)
**Solusi:**
- Database (app.db) akan dibuat otomatis
- Uninstall app dan reinstall:
  ```bash
  flutter clean
  flutter run
  ```

### Problem 6: "Waiting for connection from the VM"
**Solusi:**
- Tunggu 30 detik (proses compilation)
- Atau tekan `q` dan coba lagi:
  ```bash
  flutter run -d chrome
  ```

### Problem 7: Port sudah digunakan (Web)
**Solusi:**
```bash
flutter run -d chrome --port 8081
```

---

## 📱 TESTING SETELAH RUN

Setelah app berhasil run:

### 1. Test Register:
- Klik "Daftar di sini"
- Isi form: Name, Email, Password, Confirm Password
- Klik "Daftar"
- Verifikasi: Success message + kembali ke login

### 2. Test Login:
- Isi email & password yang sudah register
- Klik "Login"
- Verifikasi: Success message + masuk dashboard

### 3. Test Database:
- Data tersimpan di `app.db`
- Coba register user yang sama → Error "Email sudah terdaftar"
- Restart app → Login tetap berfungsi (data persisted)

---

## 🎯 OPSI PILIHAN UNTUK SETIAP KASUS

### Kalau ingin development cepat:
```bash
flutter run -d chrome
```

### Kalau ingin test di Android:
```bash
flutter run
```

### Kalau ingin production build Android:
```bash
flutter build apk
```

### Kalau ada error:
```bash
flutter clean && flutter pub get && flutter run -d chrome
```

---

## 📝 SCRIPT OTOMATIS

### Untuk macOS/Linux:
```bash
chmod +x RUN_GUIDE.sh
./RUN_GUIDE.sh
```

### Untuk Windows (PowerShell):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\RUN_GUIDE.ps1
```

---

## 💡 TIPS

1. **Pertama kali run?** → Gunakan WEB (`flutter run -d chrome`)
2. **Ingin cepat?** → Gunakan `--release` flag
3. **Ada banyak error?** → `flutter clean && flutter pub get && flutter run`
4. **Device tidak terdeteksi?** → Run `flutter devices`
5. **Mau debugging?** → Lihat log di Android Studio / DevTools

---

## 📊 PERBANDINGAN OPSI

| Platform | Setup | Kecepatan | Rekomendasi |
|----------|-------|-----------|-------------|
| **WEB** | Paling mudah | Cepat | ✅ Untuk testing |
| **Android** | Medium | Medium | ✅ Untuk Android users |
| **iOS** | Sulit (macOS) | Medium | ⏳ Untuk iOS users |
| **Windows** | Medium | Cepat | ✅ Desktop app |
| **Linux** | Sulit | Cepat | ⏳ Desktop app |

---

## 🚀 COMMAND COPY-PASTE SIAP PAKAI

### Setup + Run Web:
```bash
flutter clean && flutter pub get && flutter run -d chrome
```

### Setup + Run Android:
```bash
flutter clean && flutter pub get && flutter run
```

### Setup + Run Windows:
```bash
flutter clean && flutter pub get && flutter run -d windows
```

### Setup + Run dengan Release:
```bash
flutter clean && flutter pub get && flutter run --release
```

---

## 📞 BUTUH BANTUAN?

1. **Baca QUICK_START.md** - Quick reference
2. **Baca RUN_GUIDE.sh** - Detailed guide (macOS/Linux)
3. **Baca RUN_GUIDE.ps1** - Detailed guide (Windows)
4. **Lihat SQLITE_INTEGRATION.md** - Technical details

---

## ✅ CHECKLIST SEBELUM RUN

- [ ] Flutter sudah terinstall: `flutter --version`
- [ ] Git sudah terinstall: `git --version`
- [ ] Android SDK/Emulator siap (kalau mau Android)
- [ ] Chrome installed (kalau mau WEB)
- [ ] Project sudah di-clone/extract
- [ ] Sudah masuk ke folder project

Jika semua OK, jalankan:
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

---

**Happy Coding! 🚀**

Untuk info lebih detail, lihat file `QUICK_START.md` atau `SQLITE_INTEGRATION.md`
