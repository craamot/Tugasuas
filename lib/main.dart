import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Pengingat Jadwal Kuliah',
            theme: ThemeData(
              primaryColor: Color(0xFF7494EC),
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              fontFamily: GoogleFonts.poppins().fontFamily,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF7494EC),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7494EC),
                  foregroundColor: Colors.white,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7494EC)),
                ),
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: Color(0xFF7494EC),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Color(0xFF121212),
              fontFamily: GoogleFonts.poppins().fontFamily,
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFF1E1E1E),
                foregroundColor: Color(0xFF9BB6F7),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7494EC),
                  foregroundColor: Colors.white,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7494EC)),
                ),
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: LoginPage(),
            routes: {
              '/login': (context) => LoginPage(),
              '/dashboard': (context) => DashboardPage(),
            },
          );
        },
      ),
    );
  }
}
