import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:io' show Platform;
import '../models/user.dart';

// Import path_provider untuk desktop platforms
import 'package:path_provider/path_provider.dart' as path_provider;

/// Database Helper untuk mengelola operasi database SQLite
/// Class ini menangani semua operasi CRUD (Create, Read, Update, Delete) ke database
class DatabaseHelper {
  // Singleton pattern - memastikan hanya ada satu instance DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Variable untuk menyimpan database reference
  static Database? _database;

  // Nama database dan tabel
  static const String _dbName = 'app.db';
  static const String _tableName = 'users';

  /// Getter untuk mengakses database
  /// Jika database belum diinisialisasi, akan memanggil _initializeDatabase()
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  /// Inisialisasi database
  /// Membuat file database di aplikasi documents directory
  /// dan membuat table jika belum ada
  Future<Database> _initializeDatabase() async {
    // Untuk web, gunakan in-memory database
    if (Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isAndroid ||
        Platform.isIOS) {
      try {
        // Desktop/Mobile - gunakan file system
        final directory = await path_provider
            .getApplicationDocumentsDirectory();
        final path = join(directory.path, _dbName);

        return await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) async {
            await _createTable(db);
          },
        );
      } catch (e) {
        // Fallback ke in-memory jika gagal
        print('📱 Fallback ke in-memory database: $e');
        return await openDatabase(
          inMemoryDatabasePath,
          version: 1,
          onCreate: (db, version) async {
            await _createTable(db);
          },
        );
      }
    } else {
      // Web atau platform lain - gunakan in-memory database
      return await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          await _createTable(db);
        },
      );
    }
  }

  /// Membuat tabel users
  /// Tabel ini menyimpan data pengguna yang terdaftar
  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Seed user default untuk testing
    await _seedDefaultUser(db);
  }

  /// Seed user default untuk testing
  /// User ini bisa digunakan untuk login testing
  Future<void> _seedDefaultUser(Database db) async {
    try {
      String hashedPassword = _hashPassword('elderrizky');

      await db.insert(_tableName, {
        'name': 'Sigit Maulana',
        'email': 'sigit@gmail.com',
        'password': hashedPassword,
      });
      print('✅ Default user created successfully!');
    } catch (e) {
      print('⚠️ Default user already exists or error: $e');
    }
  }

  /// Fungsi untuk hash password (sederhana dengan MD5)
  /// CATATAN: Untuk production, gunakan algoritma yang lebih aman seperti bcrypt
  String _hashPassword(String password) {
    return md5.convert(password.codeUnits).toString();
  }

  /// Register/Daftar user baru
  /// Menambahkan user baru ke database jika email belum terdaftar
  /// Returns: true jika berhasil, false jika email sudah terdaftar
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final db = await database;

      // Cek apakah email sudah terdaftar
      if (await isEmailExists(email)) {
        return false; // Email sudah terdaftar
      }

      // Hash password sebelum menyimpan
      String hashedPassword = _hashPassword(password);

      // Membuat object User baru
      User newUser = User(name: name, email: email, password: hashedPassword);

      // Menyimpan ke database
      await db.insert(_tableName, newUser.toMap());
      return true; // Registrasi berhasil
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  /// Login user
  /// Mengecek apakah email dan password cocok dengan data di database
  /// Returns: User object jika login berhasil, null jika gagal
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final db = await database;

      // Hash password untuk dibandingkan dengan yang ada di database
      String hashedPassword = _hashPassword(password);

      // Query user berdasarkan email dan password
      final List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: 'email = ? AND password = ?',
        whereArgs: [email, hashedPassword],
      );

      // Jika ditemukan data user, return User object
      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
      return null; // User tidak ditemukan
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  /// Cek apakah email sudah terdaftar di database
  /// Returns: true jika email sudah ada, false jika belum
  Future<bool> isEmailExists(String email) async {
    try {
      final db = await database;

      // Query untuk mencari user dengan email tertentu
      final List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: 'email = ?',
        whereArgs: [email],
      );

      return result.isNotEmpty; // Return true jika email ditemukan
    } catch (e) {
      print('Error checking email: $e');
      return false;
    }
  }

  /// Mendapatkan semua user (untuk testing/debugging)
  Future<List<User>> getAllUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(_tableName);
      return result.map((map) => User.fromMap(map)).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  /// Delete semua data user (untuk testing/reset)
  Future<void> deleteAllUsers() async {
    try {
      final db = await database;
      await db.delete(_tableName);
    } catch (e) {
      print('Error deleting all users: $e');
    }
  }

  /// Close database connection
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
