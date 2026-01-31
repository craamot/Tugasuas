// FILE CONTOH PENGGUNAAN DATABASE HELPER
// Gunakan sebagai reference untuk implementasi di file lain

import '../database/db_helper.dart';
import '../models/user.dart';

/// Contoh 1: Register User Baru
void exampleRegister() async {
  final db = DatabaseHelper();
  
  // Attempt registrasi dengan email baru
  bool success = await db.registerUser(
    name: "Andi Wijaya",
    email: "andi@email.com",
    password: "password123",
  );
  
  if (success) {
    print("✅ User berhasil didaftarkan!");
  } else {
    print("❌ Email sudah terdaftar di database");
  }
}

/// Contoh 2: Login User
void exampleLogin() async {
  final db = DatabaseHelper();
  
  // Attempt login
  User? user = await db.loginUser(
    email: "andi@email.com",
    password: "password123",
  );
  
  if (user != null) {
    print("✅ Login berhasil!");
    print("   ID: ${user.id}");
    print("   Name: ${user.name}");
    print("   Email: ${user.email}");
  } else {
    print("❌ Email atau password salah");
  }
}

/// Contoh 3: Cek Email Sudah Ada
void exampleCheckEmail() async {
  final db = DatabaseHelper();
  
  bool exists = await db.isEmailExists("andi@email.com");
  
  if (exists) {
    print("⚠️ Email sudah terdaftar");
  } else {
    print("✅ Email belum terdaftar, bisa didaftarkan");
  }
}

/// Contoh 4: Ambil Semua User (untuk debug/testing)
void exampleGetAllUsers() async {
  final db = DatabaseHelper();
  
  List<User> users = await db.getAllUsers();
  
  print("📋 Total user di database: ${users.length}");
  
  for (User user in users) {
    print("   - ${user.name} (${user.email})");
  }
}

/// Contoh 5: Reset Database (Hapus Semua User)
void exampleDeleteAllUsers() async {
  final db = DatabaseHelper();
  
  await db.deleteAllUsers();
  
  print("🗑️ Semua user sudah dihapus");
}

/// Contoh 6: Password Hash Function
void examplePasswordHash() {
  // Demonstrasi bagaimana password di-hash menggunakan MD5
  // Saat user register dengan password "password123"
  
  String password = "password123";
  // Di-hash menjadi: 482c811da5d5b4bc6d497ffa98491e38
  
  // Saat login, password yang diinput juga di-hash
  // Lalu dibandingkan dengan yang ada di database
  
  print("Password original: $password");
  print("Password hashed: (tersimpan di database)");
  print("Saat login: input password → hash → compare dengan database");
}

/// BEST PRACTICE TIPS:
/// 
/// 1. SELALU validasi input sebelum kirim ke database
///    ✅ Good:
///    if (email.isNotEmpty && email.contains('@')) {
///      await db.registerUser(...);
///    }
///    
///    ❌ Bad:
///    await db.registerUser(email: email);  // tanpa validasi
///
/// 2. GUNAKAN try-catch untuk error handling
///    ✅ Good:
///    try {
///      User? user = await db.loginUser(...);
///    } catch (e) {
///      print('Error: $e');
///    }
///
/// 3. TAMPILKAN feedback ke user (SnackBar/Toast/Dialog)
///    ✅ Good:
///    if (success) {
///      ScaffoldMessenger.of(context).showSnackBar(
///        SnackBar(content: Text('Registrasi berhasil!'))
///      );
///    }
///
/// 4. GUNAKAN Singleton pattern (DatabaseHelper sudah implemented)
///    ✅ Good:
///    DatabaseHelper db = DatabaseHelper();  // Selalu instance yang sama
///
/// 5. HANDLE null dengan benar
///    ✅ Good:
///    User? user = await db.loginUser(...);
///    if (user != null) {
///      // Process user
///    }
///
/// 6. JANGAN hardcode password di code
///    ❌ Bad:
///    final password = "admin123";  // Di-hardcode
///    
///    ✅ Good:
///    String password = _passwordController.text;  // Dari user input
///
/// 7. SELALU close database saat app ditutup
///    ✅ Good:
///    await DatabaseHelper().closeDatabase();
///
/// 8. UNTUK PRODUCTION, upgrade password hashing
///    ❌ Current (Development):
///    String hashedPassword = md5.convert(password.codeUnits).toString();
///    
///    ✅ Production:
///    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
///    bool isValid = BCrypt.checkpw(password, hashedPassword);
