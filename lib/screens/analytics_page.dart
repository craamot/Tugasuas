import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<Tugas> _tugas = [];
  List<Jadwal> _jadwal = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tugasData = await DataManager.loadTugas();
    final jadwalData = await DataManager.loadJadwal();

    setState(() {
      _tugas = tugasData;
      _jadwal = jadwalData;
      _isLoading = false;
    });
  }

  int get _totalTugas => _tugas.length;
  int get _selesai => _tugas.where((t) => t.selesai).length;
  int get _belumSelesai => _totalTugas - _selesai;
  double get _progressPercentage =>
      _totalTugas == 0 ? 0 : (_selesai / _totalTugas) * 100;

  Map<String, int> _getTugasByMataKuliah() {
    Map<String, int> tugasByMK = {};
    for (var tugas in _tugas) {
      String mk = tugas.mataKuliah ?? 'Lainnya';
      tugasByMK[mk] = (tugasByMK[mk] ?? 0) + 1;
    }
    return tugasByMK;
  }

  Map<String, int> _getTugasSelesaiByMataKuliah() {
    Map<String, int> selesaiByMK = {};
    for (var tugas in _tugas.where((t) => t.selesai)) {
      String mk = tugas.mataKuliah ?? 'Lainnya';
      selesaiByMK[mk] = (selesaiByMK[mk] ?? 0) + 1;
    }
    return selesaiByMK;
  }

  List<BarChartGroupData> _getBarChartData() {
    final tugasByMK = _getTugasByMataKuliah();
    final selesaiByMK = _getTugasSelesaiByMataKuliah();

    final entries = tugasByMK.entries.toList();
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < entries.length; i++) {
      final mk = entries[i].key;
      final total = entries[i].value.toDouble();
      final selesai = selesaiByMK[mk]?.toDouble() ?? 0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: selesai, color: Color(0xFF7494EC), width: 12),
            BarChartRodData(
              toY: total - selesai,
              color: Colors.red[300]!,
              width: 12,
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subtextColor = isDark ? Colors.white70 : Colors.grey[700]!;
    Color primaryColor = Color(0xFF7494EC);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Analisis')),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      );
    }

    final tugasByMK = _getTugasByMataKuliah();
    final barGroups = _getBarChartData();

    return Scaffold(
      appBar: AppBar(title: Text('Analisis Tugas'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Progress Section
                _buildProgressSection(
                  isDark,
                  backgroundColor,
                  textColor,
                  subtextColor,
                  primaryColor,
                ),
                SizedBox(height: 24),

                // Statistics Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        isDark,
                        backgroundColor,
                        '${_totalTugas}',
                        'Total Tugas',
                        Colors.blue[400]!,
                        Icons.assignment,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        isDark,
                        backgroundColor,
                        '${_selesai}',
                        'Selesai',
                        Colors.green[400]!,
                        Icons.check_circle,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        isDark,
                        backgroundColor,
                        '${_belumSelesai}',
                        'Belum Selesai',
                        Colors.red[400]!,
                        Icons.pending,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Bar Chart
                if (barGroups.isNotEmpty) ...[
                  Text(
                    'Progres Tugas Per Mata Kuliah',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: tugasByMK.values
                            .reduce((a, b) => a > b ? a : b)
                            .toDouble(),
                        barGroups: barGroups,
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(),
                          rightTitles: AxisTitles(),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final entries = tugasByMK.entries.toList();
                                if (value.toInt() < entries.length) {
                                  String title = entries[value.toInt()].key;
                                  if (title.length > 10) {
                                    title = title.substring(0, 10) + '...';
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],

                // Legend
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Color(0xFF7494EC),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Selesai',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Belum Selesai',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    bool isDark,
    Color backgroundColor,
    Color textColor,
    Color subtextColor,
    Color primaryColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Keseluruhan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progressPercentage / 100,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_progressPercentage.toStringAsFixed(1)}% Selesai',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              Text(
                '$_selesai dari $_totalTugas',
                style: TextStyle(fontSize: 12, color: subtextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    bool isDark,
    Color backgroundColor,
    String value,
    String label,
    Color accentColor,
    IconData icon,
  ) {
    Color textColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 28),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: textColor)),
        ],
      ),
    );
  }
}
