import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'register_page.dart';

/// Halaman Login
/// User dapat login dengan email dan password yang sudah terdaftar
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers untuk input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Global key untuk form validation
  final _formKey = GlobalKey<FormState>();

  // Variable untuk loading state
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true; // Toggle show/hide password
  List<String> _loginHistory = [];

  @override
  void initState() {
    super.initState();
    _loadLoginHistory();
  }

  Future<void> _loadLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loginHistory = prefs.getStringList('login_history') ?? [];
      _rememberMe = prefs.getBool('remember_me') ?? false;
      
      // Auto-fill jika remember_me aktif
      if (_rememberMe) {
        String? lastEmail = prefs.getString('last_email');
        String? lastPassword = prefs.getString('last_password');
        if (lastEmail != null && lastPassword != null) {
          _emailController.text = lastEmail;
          _passwordController.text = lastPassword;
        }
      }
    });
  }

  Future<void> _saveLoginCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Simpan ke history jika belum ada
    if (!_loginHistory.contains(email)) {
      _loginHistory.add(email);
      await prefs.setStringList('login_history', _loginHistory);
    }
    
    // Simpan last login jika remember_me aktif
    if (_rememberMe) {
      await prefs.setString('last_email', email);
      await prefs.setString('last_password', password);
      await prefs.setBool('remember_me', true);
    }
  }

  @override
  void dispose() {
    // Membersihkan controllers saat widget di-dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Fungsi untuk handle login
  /// Mengecek validasi form, lalu melakukan query ke database
  Future<void> _handleLogin() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Ambil email dan password dari input fields
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Validasi tidak boleh kosong
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email dan password tidak boleh kosong!'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // MODE TESTING: Terima semua email dan password
      // Buat user object langsung tanpa query database
      User testUser = User(
        name: email.split('@')[0], // Ambil nama dari email
        email: email,
        password: password,
        id: 1,
      );

      // Simpan login credentials
      await _saveLoginCredentials(email, password);

      // Langsung masuk ke dashboard
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login berhasil! Selamat datang ${testUser.name}'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigasi ke Dashboard setelah 2 detik
        await Future.delayed(Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      }
    } catch (e) {
      // Handle error
      print('Login error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Set loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: isDark ? Color(0xFF121212) : Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo atau header
                SizedBox(height: 20),
                Center(
                  child: Icon(
                    Icons.lock,
                    size: 80,
                    color: Color(0xFF7494EC),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Selamat Datang',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Masuk ke akun Anda',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey,
                  ),
                ),
                SizedBox(height: 40),

                // Email field
                Text(
                  'Email',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email Anda',
                    hintStyle: GoogleFonts.poppins(
                      color: isDark ? Colors.grey[600] : Color(0xFF888888),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: isDark ? Colors.grey[500] : Colors.grey,
                    ),
                    filled: true,
                    fillColor: isDark ? Color(0xFF1E1E1E) : Color(0xFFEFEFEF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? Color(0xFF333333) : Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? Color(0xFF333333) : Colors.transparent,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  // Validator untuk email
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    // Cek format email
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Login History Dropdown
                if (_loginHistory.isNotEmpty) ...[
                  Text(
                    'Riwayat Login',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Pilih email sebelumnya',
                      hintStyle: GoogleFonts.poppins(
                        color: isDark ? Colors.grey[600] : Color(0xFF888888),
                      ),
                      prefixIcon: Icon(
                        Icons.history,
                        color: isDark ? Colors.grey[500] : Colors.grey,
                      ),
                      filled: true,
                      fillColor: isDark ? Color(0xFF1E1E1E) : Color(0xFFEFEFEF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? Color(0xFF333333) : Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? Color(0xFF333333) : Colors.transparent,
                        ),
                      ),
                    ),
                    items: _loginHistory.map((email) {
                      return DropdownMenuItem(
                        value: email,
                        child: Text(email, style: GoogleFonts.poppins()),
                      );
                    }).toList(),
                    onChanged: (email) {
                      if (email != null) {
                        _emailController.text = email;
                        _passwordController.clear();
                      }
                    },
                  ),
                  SizedBox(height: 20),
                ],

                // Password field
                Text(
                  'Password',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password Anda',
                    hintStyle: GoogleFonts.poppins(
                      color: isDark ? Colors.grey[600] : Color(0xFF888888),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: isDark ? Colors.grey[500] : Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: isDark ? Colors.grey[500] : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: isDark ? Color(0xFF1E1E1E) : Color(0xFFEFEFEF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? Color(0xFF333333) : Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? Color(0xFF333333) : Colors.transparent,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  // Validator untuk password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Remember Me Checkbox
                CheckboxListTile(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  title: Text(
                    'Ingat saya',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Color(0xFF7494EC),
                  checkColor: Colors.white,
                ),
                SizedBox(height: 15),

                // Login button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7494EC),
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: Text(
                        'Daftar di sini',
                        style: GoogleFonts.poppins(
                          color: Color(0xFF7494EC),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

