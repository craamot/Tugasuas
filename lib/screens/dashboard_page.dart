import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'input_mk_page.dart';
import 'atur_jadwal_page.dart';
import 'pengingat_tugas_page.dart';
import 'laporan_tugas_page.dart';
import 'profil_page.dart';
import 'calendar_view_page.dart';
import 'analytics_page.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';
import '../providers/theme_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Tugas> _tugas = [];

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTugas(); // Refresh data setiap kali kembali ke page
  }

  Future<void> _loadTugas() async {
    final tugasData = await DataManager.loadTugas();
    setState(() {
      _tugas = tugasData;
    });
  }

  int get _totalTugas => _tugas.length;
  int get _selesai => _tugas.where((t) => t.selesai).length;
  int get _belumSelesai => _totalTugas - _selesai;
  double get _progress => _totalTugas == 0 ? 0 : (_selesai / _totalTugas) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), centerTitle: true),
      drawer: Drawer(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            bool isDark = Theme.of(context).brightness == Brightness.dark;
            Color drawerBg = isDark ? Color(0xFF1E1E1E) : Colors.white;
            Color textColor = isDark ? Colors.white : Colors.black;
            Color dividerColor = isDark ? Colors.white24 : Color(0xFF7494EC);
            Color iconColor = isDark ? Colors.white70 : Color(0xFF7494EC);

            return Container(
              color: drawerBg,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF7494EC),
                      gradient: LinearGradient(
                        colors: [Color(0xFF7494EC), Color(0xFF9BB6F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      'Menu Navigasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.book, color: iconColor),
                    title: Text('Input MK', style: TextStyle(color: textColor)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InputMKPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.schedule, color: iconColor),
                    title: Text(
                      'Atur Jadwal',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AturJadwalPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications, color: iconColor),
                    title: Text(
                      'Pengingat Tugas',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PengingatTugasPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.report, color: iconColor),
                    title: Text(
                      'Laporan Tugas',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LaporanTugasPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month, color: iconColor),
                    title: Text(
                      'Kalender Jadwal',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarViewPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.bar_chart, color: iconColor),
                    title: Text(
                      'Analisis tugas',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalyticsPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: iconColor),
                    title: Text(
                      'Profil Mahasiswa',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilPage()),
                      );
                    },
                  ),
                  Divider(color: dividerColor),
                  ListTile(
                    leading: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: iconColor,
                    ),
                    title: Text(
                      themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      themeProvider.toggleDarkMode();
                      Navigator.pop(context);
                    },
                  ),
                  Divider(color: dividerColor),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Logout'),
                            content: Text('Apakah kamu yakin ingin logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/login');
                                },
                                child: Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            bool isDark = Theme.of(context).brightness == Brightness.dark;
            Color textColor = isDark ? Colors.white : Colors.black;
            Color subtextColor = isDark ? Colors.white70 : Colors.black87;
            double chartSize = isMobile ? 150 : 200;
            double padding = isMobile ? 16.0 : 32.0;
            return Padding(
              padding: EdgeInsets.all(padding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sambutan
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.school,
                            size: isMobile ? 80 : 100,
                            color: Color(0xFF7494EC),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Selamat Datang di Dashboard!',
                            style: TextStyle(
                              fontSize: isMobile ? 20 : 24,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Kelola jadwal kuliah dan tugas Anda dengan mudah.',
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              color: subtextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    // Ringkasan Tugas
                    Center(
                      child: Text(
                        'Ringkasan Tugas',
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Doughnut Chart
                    Container(
                      height: chartSize,
                      child: PieChart(
                        PieChartData(
                          sections: _totalTugas == 0
                              ? [
                                  PieChartSectionData(
                                    value: 1,
                                    title: 'Tidak ada\ntugas',
                                    color: Colors.grey,
                                    radius: chartSize / 3,
                                    titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]
                              : [
                                  PieChartSectionData(
                                    value: _selesai.toDouble(),
                                    title: 'Selesai\n$_selesai',
                                    color: Colors.green,
                                    radius: chartSize / 3,
                                    titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: _belumSelesai.toDouble(),
                                    title: 'Belum\n$_belumSelesai',
                                    color: Color(0xFF7494EC),
                                    radius: chartSize / 3,
                                    titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                          sectionsSpace: 2,
                          centerSpaceRadius: chartSize / 6,
                          centerSpaceColor: Colors.white,
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              if (event is FlTapUpEvent &&
                                  pieTouchResponse != null &&
                                  pieTouchResponse.touchedSection != null) {
                                final touchedIndex = pieTouchResponse
                                    .touchedSection!
                                    .touchedSectionIndex;
                                String message;
                                if (_totalTugas == 0) {
                                  message = 'Tidak ada tugas';
                                } else if (touchedIndex == 0) {
                                  message =
                                      'Tugas selesai: $_selesai dari $_totalTugas';
                                } else {
                                  message =
                                      'Tugas belum selesai: $_belumSelesai dari $_totalTugas';
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Center Progress Text
                    Center(
                      child: Text(
                        _totalTugas == 0
                            ? 'Belum ada tugas'
                            : '${_progress.toStringAsFixed(1)}% Selesai',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadTugas,
        child: Icon(Icons.refresh),
        tooltip: 'Refresh Data',
      ),
    );
  }
}
