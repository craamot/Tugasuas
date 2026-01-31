/// Model User untuk menyimpan data pengguna
/// Kelas ini mewakili struktur data pengguna dalam database
class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  /// Constructor untuk membuat object User
  /// [id] - ID unik pengguna (auto-generated dari database)
  /// [name] - Nama lengkap pengguna
  /// [email] - Email pengguna (unique)
  /// [password] - Password terenkripsi/hashed pengguna
  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  /// Convert User object ke Map untuk database
  /// Map ini digunakan saat menyimpan data ke database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  /// Create User object dari Map (dari database)
  /// Factory constructor ini digunakan untuk mengubah data dari database ke object User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
