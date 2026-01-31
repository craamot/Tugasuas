# 🚀 RUN FLUTTER APP - WINDOWS GUIDE
# File ini untuk Windows PowerShell/Command Prompt

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         🚀 RUN FLUTTER APP - PENGINGAT JADWAL (WINDOWS)       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "📱 Pilih opsi untuk menjalankan aplikasi:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1. Android (Emulator atau Device)"
Write-Host "   2. Web (Chrome Browser) - PALING MUDAH"
Write-Host "   3. Windows Desktop"
Write-Host "   4. Help - Lihat troubleshooting"
Write-Host ""

# ============================================================
# SETUP PERTAMA KALI
# ============================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "🔧 SETUP PERTAMA KALI (WAJIB DILAKUKAN DULU)" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "1️⃣  Buka Command Prompt/PowerShell di folder project"
Write-Host "   (Klik kanan -> Open PowerShell window here)" -ForegroundColor Gray
Write-Host ""
Write-Host "2️⃣  Clean project"
Write-Host "   " -NoNewline
Write-Host "flutter clean" -ForegroundColor Cyan
Write-Host ""
Write-Host "3️⃣  Get dependencies"
Write-Host "   " -NoNewline
Write-Host "flutter pub get" -ForegroundColor Cyan
Write-Host ""
Write-Host "4️⃣  Check Flutter setup"
Write-Host "   " -NoNewline
Write-Host "flutter doctor" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# ANDROID
# ============================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "1️⃣  ANDROID (Emulator atau USB Device)" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "📋 PERSIAPAN:" -ForegroundColor Yellow
Write-Host "   ✓ Buka Android Studio"
Write-Host "   ✓ Buka Android Emulator atau hubungkan device via USB"
Write-Host ""
Write-Host "✅ COMMAND UNTUK RUN:" -ForegroundColor Green
Write-Host ""
Write-Host "   Option A: Auto (rekomendasi)" -ForegroundColor Cyan
Write-Host "   " -NoNewline
Write-Host "flutter run" -ForegroundColor White
Write-Host ""
Write-Host "   Option B: Release mode (lebih cepat)" -ForegroundColor Cyan
Write-Host "   " -NoNewline
Write-Host "flutter run --release" -ForegroundColor White
Write-Host ""
Write-Host "   Option C: Lihat device yang tersedia" -ForegroundColor Cyan
Write-Host "   " -NoNewline
Write-Host "flutter devices" -ForegroundColor White
Write-Host ""

# ============================================================
# WEB
# ============================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "2️⃣  WEB (Chrome Browser) - PALING MUDAH" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "📋 PERSIAPAN:" -ForegroundColor Yellow
Write-Host "   ✓ Google Chrome sudah terinstall"
Write-Host ""
Write-Host "✅ COMMAND UNTUK RUN:" -ForegroundColor Green
Write-Host ""
Write-Host "   " -NoNewline
Write-Host "flutter run -d chrome" -ForegroundColor White
Write-Host ""
Write-Host "   Maka app akan otomatis membuka di Chrome!" -ForegroundColor Gray
Write-Host ""

# ============================================================
# WINDOWS DESKTOP
# ============================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "3️⃣  WINDOWS DESKTOP" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "📋 PERSIAPAN:" -ForegroundColor Yellow
Write-Host "   ✓ Visual Studio atau Visual Studio Build Tools"
Write-Host ""
Write-Host "✅ COMMAND UNTUK RUN:" -ForegroundColor Green
Write-Host ""
Write-Host "   " -NoNewline
Write-Host "flutter run -d windows" -ForegroundColor White
Write-Host ""

# ============================================================
# TROUBLESHOOTING
# ============================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "⚠️  TROUBLESHOOTING" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""

Write-Host "Problem: 'Plugin not found' atau compilation error" -ForegroundColor Red
Write-Host "Solution:" -ForegroundColor Yellow
Write-Host "   1. " -NoNewline
Write-Host "flutter clean" -ForegroundColor Cyan
Write-Host "   2. " -NoNewline
Write-Host "flutter pub get" -ForegroundColor Cyan
Write-Host "   3. " -NoNewline
Write-Host "flutter run" -ForegroundColor Cyan
Write-Host ""

Write-Host "Problem: 'No device found'" -ForegroundColor Red
Write-Host "Solution:" -ForegroundColor Yellow
Write-Host "   - Buka Android Emulator terlebih dahulu" -ForegroundColor Gray
Write-Host "   - Atau hubungkan Android device via USB" -ForegroundColor Gray
Write-Host "   - Atau gunakan: " -NoNewline
Write-Host "flutter run -d chrome" -ForegroundColor Cyan
Write-Host ""

Write-Host "Problem: 'Cannot find device'" -ForegroundColor Red
Write-Host "Solution:" -ForegroundColor Yellow
Write-Host "   " -NoNewline
Write-Host "flutter devices" -ForegroundColor Cyan
Write-Host "   untuk melihat device yang tersedia" -ForegroundColor Gray
Write-Host ""

Write-Host "Problem: Database error saat register/login" -ForegroundColor Red
Write-Host "Solution:" -ForegroundColor Yellow
Write-Host "   - Database (app.db) akan dibuat otomatis" -ForegroundColor Gray
Write-Host "   - Uninstall dan reinstall app jika ada masalah" -ForegroundColor Gray
Write-Host ""

# ============================================================
# RECOMMENDED
# ============================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "✨ REKOMENDASI TERCEPAT (COPY PASTE KE TERMINAL)" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "Untuk menjalankan WEB (paling mudah):" -ForegroundColor Cyan
Write-Host "   " -NoNewline
Write-Host "flutter clean && flutter pub get && flutter run -d chrome" -ForegroundColor White
Write-Host ""
Write-Host "Atau untuk Android:" -ForegroundColor Cyan
Write-Host "   " -NoNewline
Write-Host "flutter clean && flutter pub get && flutter run" -ForegroundColor White
Write-Host ""

# ============================================================
# INFO
# ============================================================
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  📚 Untuk informasi lebih detail, buka file: QUICK_START.md   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Happy Coding! 🚀" -ForegroundColor Green
Write-Host ""
