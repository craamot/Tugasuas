import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';

class PengingatTugasPage extends StatefulWidget {
  const PengingatTugasPage({super.key});

  @override
  _PengingatTugasPageState createState() => _PengingatTugasPageState();
}

class _PengingatTugasPageState extends State<PengingatTugasPage> {
  final TextEditingController _tugasController = TextEditingController();
  List<Tugas> _tugas = [];
  List<MataKuliah> _mataKuliah = [];
  List<Jadwal> _jadwal = [];
  String? _selectedMK;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tugasData = await DataManager.loadTugas();
    final mkData = await DataManager.loadMataKuliah();
    final jadwalData = await DataManager.loadJadwal();
    setState(() {
      _tugas = tugasData;
      _mataKuliah = mkData;
      _jadwal = jadwalData;
    });
  }

  Future<void> _saveData() async {
    await DataManager.saveTugas(_tugas);
  }

  void _addTugas() {
    if (_tugasController.text.isNotEmpty) {
      setState(() {
        _tugas.add(
          Tugas(
            deskripsi: _tugasController.text,
            mataKuliah: _selectedMK,
            tanggal: _selectedDate,
            waktu: _selectedTime,
          ),
        );
        _tugasController.clear();
        _selectedMK = null;
        _selectedDate = null;
        _selectedTime = null;
      });
      _saveData();
    }
  }

  void _editTugas(int index) {
    _tugasController.text = _tugas[index].deskripsi;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Tugas'),
        content: TextField(
          controller: _tugasController,
          decoration: InputDecoration(labelText: 'Deskripsi Tugas'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _tugasController.clear();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _tugas[index] = Tugas(
                  deskripsi: _tugasController.text,
                  selesai: _tugas[index].selesai,
                );
              });
              _saveData();
              Navigator.of(context).pop();
              _tugasController.clear();
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteTugas(int index) {
    setState(() {
      _tugas.removeAt(index);
    });
    _saveData();
  }

  void _toggleSelesai(int index) {
    setState(() {
      _tugas[index].selesai = !_tugas[index].selesai;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final dropdownColor = isDark ? Color(0xFF2A2A2A) : Colors.white;
    
    return Scaffold(
      appBar: AppBar(title: Text('Pengingat Tugas'), centerTitle: true),
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
                controller: _tugasController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                  prefixIcon: Icon(Icons.task, color: Color(0xFF7494EC)),
                  fillColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                style: TextStyle(color: textColor),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedMK,
                decoration: InputDecoration(
                  labelText: 'Mata Kuliah (Opsional)',
                  prefixIcon: Icon(Icons.book, color: Color(0xFF7494EC)),
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                  fillColor: isDark ? Color(0xFF2A2A2A) : Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isDark ? Color(0xFF444444) : Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                dropdownColor: dropdownColor,
                style: TextStyle(color: textColor),
                items: _mataKuliah.map((mk) {
                  return DropdownMenuItem(
                    value: mk.nama,
                    child: Text(mk.nama, style: TextStyle(color: textColor)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMK = value;
                    // Auto-fill tanggal dan waktu dari jadwal
                    if (value != null) {
                      final jadwal = _jadwal.firstWhere(
                        (j) => j.mataKuliah == value,
                        orElse: () =>
                            Jadwal(mataKuliah: '', tanggal: '', waktu: ''),
                      );
                      if (jadwal.tanggal.isNotEmpty) {
                        _selectedDate = DateTime.parse(jadwal.tanggal);
                      }
                      if (jadwal.waktu.isNotEmpty) {
                        final parts = jadwal.waktu.split(':');
                        _selectedTime = TimeOfDay(
                          hour: int.parse(parts[0]),
                          minute: int.parse(parts[1]),
                        );
                      }
                    } else {
                      _selectedDate = null;
                      _selectedTime = null;
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _addTugas, child: Text('Tambah Tugas')),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _tugas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: _tugas[index].selesai
                          ? Colors.green[800]
                          : Color(0xFF7494EC),
                      child: ListTile(
                        title: Text(
                          _tugas[index].deskripsi,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: _tugas[index].selesai
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_tugas[index].mataKuliah != null)
                              Text(
                                'MK: ${_tugas[index].mataKuliah}',
                                style: TextStyle(color: Colors.white70),
                              ),
                            if (_tugas[index].tanggal != null)
                              Text(
                                'Tanggal: ${DateFormat('yyyy-MM-dd').format(_tugas[index].tanggal!)}',
                                style: TextStyle(color: Colors.white70),
                              ),
                            if (_tugas[index].waktu != null)
                              Text(
                                'Waktu: ${_tugas[index].waktu!.format(context)}',
                                style: TextStyle(color: Colors.white70),
                              ),
                          ],
                        ),
                        leading: Checkbox(
                          value: _tugas[index].selesai,
                          onChanged: (value) => _toggleSelesai(index),
                          activeColor: Color(0xFF7494EC),
                          checkColor: Colors.white,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _editTugas(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () => _deleteTugas(index),
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
