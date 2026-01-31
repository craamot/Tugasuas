#!/bin/bash
# 🚀 RUN FLUTTER APP - GUIDE LENGKAP
# File ini berisi instruksi lengkap untuk menjalankan aplikasi

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                 🚀 RUN FLUTTER APP - PENGINGAT JADWAL         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Menampilkan pilihan platform
echo "📱 Pilih platform untuk menjalankan aplikasi:"
echo ""
echo "   1. Android (Device/Emulator)"
echo "   2. iOS (Simulator/Device) - macOS only"
echo "   3. Web Browser"
echo "   4. Windows Desktop"
echo "   5. Linux Desktop"
echo ""
echo "Atau jalankan salah satu command di bawah ini langsung:"
echo ""

# ============================================================
# ANDROID
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  ANDROID (Device atau Emulator)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 PERSIAPAN:"
echo "   a. Pastikan Android SDK sudah terinstall"
echo "   b. Buka Android Emulator ATAU hubungkan Android Device via USB"
echo ""

echo "✅ COMMAND UNTUK MENJALANKAN:"
echo ""
echo "   Option A: Default (debug mode)"
echo "   $ flutter run"
echo ""
echo "   Option B: Release mode (lebih cepat)"
echo "   $ flutter run --release"
echo ""
echo "   Option C: Specific device"
echo "   $ flutter devices                    # List all devices"
echo "   $ flutter run -d <device_id>"
echo ""

# ============================================================
# iOS
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  iOS (Simulator atau Device) - macOS ONLY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 PERSIAPAN:"
echo "   a. Pastikan macOS sudah terinstall"
echo "   b. Buka iOS Simulator ATAU hubungkan iPhone via USB"
echo ""

echo "✅ COMMAND UNTUK MENJALANKAN:"
echo ""
echo "   Option A: Default (debug mode)"
echo "   $ flutter run"
echo ""
echo "   Option B: Release mode"
echo "   $ flutter run --release"
echo ""
echo "   Option C: Specific iOS version"
echo "   $ open -a Simulator                 # Open iOS Simulator"
echo "   $ flutter run"
echo ""

# ============================================================
# WEB
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  WEB (Browser - Chrome/Firefox/Safari)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 PERSIAPAN:"
echo "   a. Chrome/Firefox/Safari sudah terinstall"
echo "   b. Flutter web sudah di-enable"
echo ""

echo "✅ COMMAND UNTUK MENJALANKAN:"
echo ""
echo "   Option A: Default (Chrome)"
echo "   $ flutter run -d chrome"
echo ""
echo "   Option B: Firefox"
echo "   $ flutter run -d firefox"
echo ""
echo "   Option C: Safari (macOS only)"
echo "   $ flutter run -d safari"
echo ""
echo "   Option D: Release mode (production)"
echo "   $ flutter run -d chrome --release"
echo ""

# ============================================================
# WINDOWS
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4️⃣  WINDOWS Desktop"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 PERSIAPAN:"
echo "   a. Pastikan Windows SDK sudah terinstall"
echo "   b. Visual Studio atau Visual Studio Code sudah siap"
echo ""

echo "✅ COMMAND UNTUK MENJALANKAN:"
echo ""
echo "   Option A: Default (debug mode)"
echo "   $ flutter run -d windows"
echo ""
echo "   Option B: Release mode"
echo "   $ flutter run -d windows --release"
echo ""

# ============================================================
# LINUX
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5️⃣  LINUX Desktop"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 PERSIAPAN:"
echo "   a. Flutter Linux development tools sudah terinstall"
echo "   b. Linux build tools sudah siap"
echo ""

echo "✅ COMMAND UNTUK MENJALANKAN:"
echo ""
echo "   Option A: Default (debug mode)"
echo "   $ flutter run -d linux"
echo ""
echo "   Option B: Release mode"
echo "   $ flutter run -d linux --release"
echo ""

# ============================================================
# SETUP UMUM
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 SETUP UMUM (Lakukan PERTAMA KALI)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1️⃣  Clean project"
echo "   $ flutter clean"
echo ""
echo "2️⃣  Get dependencies"
echo "   $ flutter pub get"
echo ""
echo "3️⃣  Check Flutter setup"
echo "   $ flutter doctor"
echo ""
echo "4️⃣  List available devices"
echo "   $ flutter devices"
echo ""
echo "5️⃣  Run app"
echo "   $ flutter run"
echo ""

# ============================================================
# TROUBLESHOOTING
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  TROUBLESHOOTING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Problem: 'Plugin not found' error"
echo "Solution:"
echo "   $ flutter clean"
echo "   $ flutter pub get"
echo ""
echo "Problem: 'No connected devices'"
echo "Solution:"
echo "   - Open Android Emulator atau connect device"
echo "   - Then run: flutter devices"
echo ""
echo "Problem: Compilation error"
echo "Solution:"
echo "   $ flutter clean"
echo "   $ flutter pub get"
echo "   $ flutter pub upgrade"
echo ""
echo "Problem: Database error"
echo "Solution:"
echo "   - App akan auto-create database (app.db)"
echo "   - Delete app dan re-install jika ada masalah"
echo ""

# ============================================================
# RECOMMENDED COMMAND
# ============================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ REKOMENDASI (PALING MUDAH)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Untuk menjalankan dengan optimal, gunakan:"
echo ""
echo "   $ flutter clean"
echo "   $ flutter pub get"
echo "   $ flutter run"
echo ""
echo "Maka app akan otomatis membuka di device yang tersedia!"
echo ""

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          📚 Lihat QUICK_START.md untuk info lebih detail       ║"
echo "╚════════════════════════════════════════════════════════════════╝"
