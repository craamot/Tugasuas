import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';

class AturJadwalPage extends StatefulWidget {
  const AturJadwalPage({super.key});

  @override
  _AturJadwalPageState createState() => _AturJadwalPageState();
}

class _AturJadwalPageState extends State<AturJadwalPage> {
  List<Jadwal> _jadwal = [];
  List<MataKuliah> _mataKuliah = [];
  String? _selectedMK;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jadwalData = await DataManager.loadJadwal();
    final mkData = await DataManager.loadMataKuliah();
    setState(() {
      _jadwal = jadwalData;
      _mataKuliah = mkData;
    });
  }

  Future<void> _saveData() async {
    await DataManager.saveJadwal(_jadwal);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addJadwal() {
    if (_selectedMK != null && _selectedDate != null && _selectedTime != null) {
      final jadwal = Jadwal(
        mataKuliah: _selectedMK!,
        tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        waktu: _selectedTime!.format(context),
      );
      setState(() {
        _jadwal.add(jadwal);
        _resetForm();
      });
      _saveData();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Isi semua field')));
    }
  }

  void _resetForm() {
    _selectedMK = null;
    _selectedDate = null;
    _selectedTime = null;
  }

  void _editJadwal(int index) {
    final jadwal = _jadwal[index];
    _selectedMK = jadwal.mataKuliah;
    _selectedDate = DateFormat('yyyy-MM-dd').parse(jadwal.tanggal);
    _selectedTime = TimeOfDay.fromDateTime(
      DateFormat('HH:mm').parse(jadwal.waktu),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text('Edit Jadwal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedMK,
                  decoration: InputDecoration(labelText: 'Mata Kuliah'),
                  items: _mataKuliah.map((mk) {
                    return DropdownMenuItem(
                      value: mk.nama,
                      child: Text(mk.nama),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      _selectedMK = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await _selectDate(context);
                    setStateDialog(() {});
                  },
                  child: Text(
                    _selectedDate == null
                        ? 'Pilih Tanggal'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await _selectTime(context);
                    setStateDialog(() {});
                  },
                  child: Text(
                    _selectedTime == null
                        ? 'Pilih Waktu'
                        : _selectedTime!.format(context),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (_selectedMK != null &&
                    _selectedDate != null &&
                    _selectedTime != null) {
                  setState(() {
                    _jadwal[index] = Jadwal(
                      mataKuliah: _selectedMK!,
                      tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      waktu: _selectedTime!.format(context),
                    );
                  });
                  _saveData();
                  Navigator.of(context).pop();
                  _resetForm();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteJadwal(int index) {
    setState(() {
      _jadwal.removeAt(index);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final dropdownColor = isDark ? Color(0xFF2A2A2A) : Colors.white;
    
    return Scaffold(
      appBar: AppBar(title: Text('Atur Jadwal'), centerTitle: true),
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
              DropdownButtonFormField<String>(
                initialValue: _selectedMK,
                decoration: InputDecoration(
                  labelText: 'Mata Kuliah',
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
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        _selectedDate == null
                            ? 'Pilih Tanggal'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: Text(
                        _selectedTime == null
                            ? 'Pilih Waktu'
                            : _selectedTime!.format(context),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addJadwal,
                      child: Text('Tambah Jadwal'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Mata Kuliah',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tanggal',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Waktu',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Aksi',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                    rows: _jadwal.map((jadwal) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              jadwal.mataKuliah,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          DataCell(
                            Text(
                              jadwal.tanggal,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          DataCell(
                            Text(
                              jadwal.waktu,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Color(0xFF7494EC),
                                  ),
                                  onPressed: () =>
                                      _editJadwal(_jadwal.indexOf(jadwal)),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Color(0xFF7494EC),
                                  ),
                                  onPressed: () =>
                                      _deleteJadwal(_jadwal.indexOf(jadwal)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
