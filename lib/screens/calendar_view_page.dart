import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  late PageController _pageController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Jadwal> _jadwalList = [];
  Map<DateTime, List<Jadwal>> _jadwalByDate = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
    _selectedDay = _focusedDay;
    _pageController = PageController();
    _loadJadwal();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('id_ID', null);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadJadwal() async {
    final jadwals = await DataManager.loadJadwal();
    final tugass = await DataManager.loadTugas();

    // Organize jadwal by date
    Map<DateTime, List<Jadwal>> jadwalMap = {};
    for (var jadwal in jadwals) {
      try {
        DateTime dateKey = DateTime.parse(jadwal.tanggal);
        DateTime normalizedDate =
            DateTime(dateKey.year, dateKey.month, dateKey.day);

        if (!jadwalMap.containsKey(normalizedDate)) {
          jadwalMap[normalizedDate] = [];
        }
        jadwalMap[normalizedDate]!.add(jadwal);
      } catch (e) {
        // Handle invalid date format
      }
    }

    setState(() {
      _jadwalList = jadwals;
      _jadwalByDate = jadwalMap;
    });
  }

  List<Jadwal> _getJadwalForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _jadwalByDate[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = Color(0xFF7494EC);
    Color backgroundColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subtextColor = isDark ? Colors.white70 : Colors.grey[700]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalender Jadwal'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadJadwal,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Calendar Widget
              Container(
                color: backgroundColor,
                padding: EdgeInsets.all(8),
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _getJadwalForDay,
                  headerStyle: HeaderStyle(
                    formatButtonDecoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: textColor),
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    todayDecoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: TextStyle(color: textColor),
                    weekendTextStyle: TextStyle(
                      color: Colors.red[400],
                    ),
                    outsideTextStyle: TextStyle(
                      color: subtextColor,
                    ),
                    markersMaxCount: 2,
                    markerDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: textColor),
                    weekendStyle: TextStyle(color: Colors.red[400]),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Selected Day Events
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwal pada ${DateFormat('EEEE, d MMMM yyyy').format(_selectedDay ?? DateTime.now())}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildJadwalList(),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJadwalList() {
    final jadwals = _getJadwalForDay(_selectedDay ?? DateTime.now());
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = Color(0xFF7494EC);
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subtextColor = isDark ? Colors.white70 : Colors.grey[700]!;

    if (jadwals.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.calendar_today,
              size: 48,
              color: primaryColor.withOpacity(0.5),
            ),
            SizedBox(height: 12),
            Text(
              'Tidak ada jadwal pada hari ini',
              style: TextStyle(
                color: subtextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: jadwals.length,
      itemBuilder: (context, index) {
        final jadwal = jadwals[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: primaryColor,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jadwal.mataKuliah,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jam: ${jadwal.waktu}',
                      style: TextStyle(
                        color: subtextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
