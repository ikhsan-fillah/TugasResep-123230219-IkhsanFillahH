import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMsg;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMsg = 'Username dan password wajib diisi.');
      return;
    }

    setState(() { _isLoading = true; _errorMsg = null; });

    final prefs = await SharedPreferences.getInstance();
    final savedPass = prefs.getString('user_$username');

    if (savedPass == null) {
      setState(() { _isLoading = false; _errorMsg = 'Akun tidak ditemukan.'; });
      return;
    }
    if (savedPass != password) {
      setState(() { _isLoading = false; _errorMsg = 'Password salah.'; });
      return;
    }

    await prefs.setString('session_username', username);
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Color(0x26FF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.restaurant_menu, color: Color(0xFFFF9800), size: 48),
                ),
                const SizedBox(height: 24),
                const Text('Selamat Datang!',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                const SizedBox(height: 6),
                const Text('Login untuk menjelajahi ribuan resep',
                    style: TextStyle(fontSize: 14, color: Color(0xFF757575))),
                const SizedBox(height: 36),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Username',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF424242))),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan username',
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFBDBDBD)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF424242))),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFBDBDBD)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFFBDBDBD)),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                if (_errorMsg != null) ...[const SizedBox(height: 10), Text(_errorMsg!, style: const TextStyle(color: Colors.red, fontSize: 13))],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun? ', style: TextStyle(fontSize: 14, color: Color(0xFF757575))),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: const Text('Daftar', style: TextStyle(fontSize: 14, color: Color(0xFFFF9800), fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
