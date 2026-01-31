import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';

class InputMKPage extends StatefulWidget {
  const InputMKPage({super.key});

  @override
  _InputMKPageState createState() => _InputMKPageState();
}

class _InputMKPageState extends State<InputMKPage> {
  final TextEditingController _mkController = TextEditingController();
  List<MataKuliah> _mataKuliah = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DataManager.loadMataKuliah();
    setState(() {
      _mataKuliah = data;
    });
  }

  Future<void> _saveData() async {
    await DataManager.saveMataKuliah(_mataKuliah);
  }

  void _addMK() {
    if (_mkController.text.isNotEmpty) {
      setState(() {
        _mataKuliah.add(MataKuliah(nama: _mkController.text));
        _mkController.clear();
      });
      _saveData();
    }
  }

  void _editMK(int index) {
    _mkController.text = _mataKuliah[index].nama;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Mata Kuliah'),
        content: TextField(
          controller: _mkController,
          decoration: InputDecoration(labelText: 'Nama Mata Kuliah'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _mkController.clear();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _mataKuliah[index] = MataKuliah(nama: _mkController.text);
              });
              _saveData();
              Navigator.of(context).pop();
              _mkController.clear();
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteMK(int index) {
    setState(() {
      _mataKuliah.removeAt(index);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    
    return Scaffold(
      appBar: AppBar(title: Text('Input Mata Kuliah'), centerTitle: true),
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
            children: [
              TextField(
                controller: _mkController,
                decoration: InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                  prefixIcon: Icon(Icons.book, color: Color(0xFF7494EC)),
                  fillColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: TextStyle(color: textColor),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _addMK, child: Text('Tambah MK')),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _mataKuliah.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color(0xFF7494EC),
                      child: ListTile(
                        title: Text(
                          _mataKuliah[index].nama,
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _editMK(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () => _deleteMK(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
