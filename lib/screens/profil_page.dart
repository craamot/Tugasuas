import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import '../models/data_models.dart';
import '../models/data_manager.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late Profil _profil;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  Uint8List? _profileImage;

  @override
  void initState() {
    super.initState();
    print('🚀 ProfilPage initState');
    _loadData();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        final imageBytes = result.files.single.bytes!;

        setState(() {
          _profileImage = imageBytes;
        });

        // Simpan image sebagai base64 ke profil model
        final imageBase64 = base64Encode(imageBytes);
        _profil.profileImageBase64 = imageBase64;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Foto profil berhasil diupload!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Gagal mengupload foto'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadData() async {
    try {
      final data = await DataManager.loadProfil();
      print('✅ _loadData success: nama=${data.nama}, nim=${data.nim}');
      if (mounted) {
        setState(() {
          _profil = data;
          _namaController.text = _profil.nama;
          _nimController.text = _profil.nim;
          _jurusanController.text = _profil.jurusan;
          _semesterController.text = _profil.semester;
          // Load profile image from profil data
          if (_profil.profileImageBase64 != null) {
            _profileImage = base64Decode(_profil.profileImageBase64!);
          }
        });
      }
    } catch (e) {
      print('❌ _loadData error: $e');
    }
  }

  Future<void> _saveData() async {
    // Validate input
    if (_namaController.text.isEmpty ||
        _nimController.text.isEmpty ||
        _jurusanController.text.isEmpty ||
        _semesterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Semua field harus diisi!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      _profil = Profil(
        nama: _namaController.text.trim(),
        nim: _nimController.text.trim(),
        jurusan: _jurusanController.text.trim(),
        semester: _semesterController.text.trim(),
        profileImageBase64: _profil.profileImageBase64, // Keep existing image
      );

      print('💾 Saving profil: nama=${_profil.nama}, nim=${_profil.nim}');
      await DataManager.saveProfil(_profil);
      print('✅ Profil saved successfully!');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Profil berhasil disimpan!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error saving profil: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: Gagal menyimpan profil - $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Mahasiswa'),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveData)],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Color(0xFF1E1E1E), Color(0xFF0F0F0F)]
                : [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF7494EC),
                          width: 3,
                        ),
                        color: isDark ? Color(0xFF2A2A2A) : Colors.white,
                      ),
                      child: _profileImage != null
                          ? ClipOval(
                              child: Image.memory(
                                _profileImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 80,
                              color: Color(0xFF7494EC),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7494EC),
                        ),
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF7494EC)),
                  filled: true,
                  fillColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Color(0xFF444444) : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Color(0xFF444444) : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nimController,
                decoration: InputDecoration(
                  labelText: 'NIM',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  prefixIcon: Icon(Icons.badge, color: Color(0xFF7494EC)),
                  filled: true,
                  fillColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Color(0xFF444444) : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Color(0xFF444444) : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _jurusanController,
                decoration: InputDecoration(
                  labelText: 'Jurusan',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  prefixIcon: Icon(Icons.school, color: Color(0xFF7494EC)),
                  filled: true,
                  fillColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Color(0xFF444444) : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Color(0xFF444444) : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _semesterController,
                decoration: InputDecoration(
                  labelText: 'Semester',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Color(0xFF7494EC),
                  ),
                  filled: true,
                  fillColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Color(0xFF444444) : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? Color(0xFF444444) : Colors.grey[300]!,
                    ),
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
