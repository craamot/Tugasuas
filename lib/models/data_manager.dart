import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'data_models.dart';

class DataManager {
  static const String _mkKey = 'mata_kuliah';
  static const String _jadwalKey = 'jadwal';
  static const String _tugasKey = 'tugas';
  static const String _profilKey = 'profil';

  // Mata Kuliah
  static Future<List<MataKuliah>> loadMataKuliah() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_mkKey);
    if (data != null) {
      final list = json.decode(data) as List;
      return list.map((e) => MataKuliah.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> saveMataKuliah(List<MataKuliah> mk) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(mk.map((e) => e.toJson()).toList());
    await prefs.setString(_mkKey, data);
  }

  // Jadwal
  static Future<List<Jadwal>> loadJadwal() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_jadwalKey);
    if (data != null) {
      final list = json.decode(data) as List;
      return list.map((e) => Jadwal.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> saveJadwal(List<Jadwal> jadwal) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(jadwal.map((e) => e.toJson()).toList());
    await prefs.setString(_jadwalKey, data);
  }

  // Tugas
  static Future<List<Tugas>> loadTugas() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_tugasKey);
    if (data != null) {
      final list = json.decode(data) as List;
      return list.map((e) => Tugas.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> saveTugas(List<Tugas> tugas) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(tugas.map((e) => e.toJson()).toList());
    await prefs.setString(_tugasKey, data);
  }

  // Profil
  static Future<Profil> loadProfil() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_profilKey);
    print('🔍 loadProfil: data=$data'); // Debug
    if (data != null && data.isNotEmpty) {
      try {
        return Profil.fromJson(json.decode(data));
      } catch (e) {
        print('❌ Error parsing profil: $e');
        return _defaultProfil();
      }
    }
    return _defaultProfil();
  }

  static Profil _defaultProfil() {
    return Profil(
      nama: 'Sigit Maulana',
      nim: '14012300066',
      jurusan: 'ILMU KOMPUTER',
      semester: '5',
    );
  }

  static Future<void> saveProfil(Profil profil) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = profil.toJson();
    final encodedData = json.encode(jsonData);
    print('💾 saveProfil: $encodedData'); // Debug
    final result = await prefs.setString(_profilKey, encodedData);
    print('✅ saveProfil result: $result'); // Debug
  }

  // DELETE FUNCTIONS

  /// Delete Mata Kuliah by index
  static Future<void> deleteMataKuliah(int index) async {
    final list = await loadMataKuliah();
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await saveMataKuliah(list);
    }
  }

  /// Delete Jadwal by index
  static Future<void> deleteJadwal(int index) async {
    final list = await loadJadwal();
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await saveJadwal(list);
    }
  }

  /// Delete Tugas by index
  static Future<void> deleteTugas(int index) async {
    final list = await loadTugas();
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await saveTugas(list);
    }
  }

  // EDIT/UPDATE FUNCTIONS

  /// Update Mata Kuliah at index
  static Future<void> updateMataKuliah(int index, MataKuliah mk) async {
    final list = await loadMataKuliah();
    if (index >= 0 && index < list.length) {
      list[index] = mk;
      await saveMataKuliah(list);
    }
  }

  /// Update Jadwal at index
  static Future<void> updateJadwal(int index, Jadwal jadwal) async {
    final list = await loadJadwal();
    if (index >= 0 && index < list.length) {
      list[index] = jadwal;
      await saveJadwal(list);
    }
  }

  /// Update Tugas at index
  static Future<void> updateTugas(int index, Tugas tugas) async {
    final list = await loadTugas();
    if (index >= 0 && index < list.length) {
      list[index] = tugas;
      await saveTugas(list);
    }
  }

  /// Toggle Tugas completion status
  static Future<void> toggleTugasSelesai(int index) async {
    final list = await loadTugas();
    if (index >= 0 && index < list.length) {
      list[index].selesai = !list[index].selesai;
      await saveTugas(list);
    }
  }
}
