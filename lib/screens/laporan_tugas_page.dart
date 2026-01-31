import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';

class LaporanTugasPage extends StatefulWidget {
  const LaporanTugasPage({super.key});

  @override
  _LaporanTugasPageState createState() => _LaporanTugasPageState();
}

class _LaporanTugasPageState extends State<LaporanTugasPage> {
  List<Tugas> _tugas = [];
  String _searchQuery = '';
  bool _filterSelesai = false;
  bool _filterBelumSelesai = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DataManager.loadTugas();
    setState(() {
      _tugas = data;
    });
  }

  Future<void> _saveData() async {
    await DataManager.saveTugas(_tugas);
  }

  List<Tugas> get _filteredTugas {
    return _tugas.where((tugas) {
      bool matchesSearch = tugas.deskripsi
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      bool matchesFilter = true;

      if (_filterSelesai || _filterBelumSelesai) {
        if (_filterSelesai && _filterBelumSelesai) {
          matchesFilter = true;
        } else if (_filterSelesai) {
          matchesFilter = tugas.selesai;
        } else if (_filterBelumSelesai) {
          matchesFilter = !tugas.selesai;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _toggleSelesai(int index) {
    setState(() {
      _tugas[index].selesai = !_tugas[index].selesai;
    });
    _saveData();
  }

  void _deleteTugas(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Tugas'),
          content: Text('Apakah kamu yakin ingin menghapus tugas ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tugas.removeAt(index);
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Tugas dihapus')),
                );
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _editTugas(int index) {
    final TextEditingController deskripsiController =
        TextEditingController(text: _tugas[index].deskripsi);
    final TextEditingController mkController =
        TextEditingController(text: _tugas[index].mataKuliah ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Tugas'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi Tugas'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: mkController,
                  decoration: InputDecoration(labelText: 'Mata Kuliah'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tugas[index].deskripsi = deskripsiController.text;
                  _tugas[index].mataKuliah = mkController.text;
                });
                _saveData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Tugas diperbarui')),
                );
              },
              child: Text('Simpan', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laporan Tugas'), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
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
              Text(
                'Daftar Tugas:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(height: 12),
              // Search field
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari tugas...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Filter chips
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: Text('Selesai'),
                    selected: _filterSelesai,
                    onSelected: (value) {
                      setState(() {
                        _filterSelesai = value;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text('Belum Selesai'),
                    selected: _filterBelumSelesai,
                    onSelected: (value) {
                      setState(() {
                        _filterBelumSelesai = value;
                      });
                    },
                  ),
                  if (_filterSelesai || _filterBelumSelesai)
                    FilterChip(
                      label: Text('Reset', style: TextStyle(color: Colors.red)),
                      onSelected: (value) {
                        setState(() {
                          _filterSelesai = false;
                          _filterBelumSelesai = false;
                          _searchQuery = '';
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 12),
              // Results count
              Text(
                'Menampilkan ${_filteredTugas.length} dari ${_tugas.length} tugas',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: _filteredTugas.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada tugas',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredTugas.length,
                        itemBuilder: (context, index) {
                          final tugas = _filteredTugas[index];
                          final actualIndex = _tugas.indexOf(tugas);
                          return Card(
                            color: tugas.selesai
                                ? Colors.green[800]
                                : Color(0xFF7494EC),
                            child: ListTile(
                              title: Text(
                                tugas.deskripsi,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: tugas.mataKuliah != null
                                  ? Text(
                                      'MK: ${tugas.mataKuliah}',
                                      style: TextStyle(color: Colors.white70),
                                    )
                                  : null,
                              leading: Checkbox(
                                value: tugas.selesai,
                                onChanged: (value) =>
                                    _toggleSelesai(actualIndex),
                                activeColor: Colors.white,
                                checkColor: Colors.black,
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.blue),
                                        SizedBox(width: 10),
                                        Text('Edit'),
                                      ],
                                    ),
                                    onTap: () => _editTugas(actualIndex),
                                  ),
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 10),
                                        Text('Hapus'),
                                      ],
                                    ),
                                    onTap: () => _deleteTugas(actualIndex),
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
