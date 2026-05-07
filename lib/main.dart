import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/meal_model.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MealAdapter());
  await Hive.openBox<Meal>('favorites');
  runApp(const ResepKuApp());
}

class ResepKuApp extends StatelessWidget {
  const ResepKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResepKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9800),
          primary: const Color(0xFFFF9800),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF9800),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('session_username');
    setState(() {
      _isLoggedIn = username != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
      );
    }
    return _isLoggedIn ? const MainScreen() : const LoginScreen();
  }
}
