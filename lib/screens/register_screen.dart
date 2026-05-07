import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMsg;

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (username.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => _errorMsg = 'Semua field wajib diisi.');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMsg = 'Password tidak cocok.');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMsg = 'Password minimal 6 karakter.');
      return;
    }

    setState(() { _isLoading = true; _errorMsg = null; });

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('user_$username');
    if (existing != null) {
      setState(() { _isLoading = false; _errorMsg = 'Username sudah digunakan.'; });
      return;
    }

    await prefs.setString('user_$username', password);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil dibuat! Silakan login.'), backgroundColor: Color(0xFFFF9800)));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0x26FF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_outlined, color: Color(0xFFFF9800), size: 42),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Username'),
              const SizedBox(height: 8),
              _buildTextField(controller: _usernameController, hint: 'Masukkan username', icon: Icons.person_outline),
              const SizedBox(height: 16),
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(controller: _passwordController, hint: 'Masukkan password', icon: Icons.lock_outline, obscure: _obscurePass, onToggle: () => setState(() => _obscurePass = !_obscurePass)),
              const SizedBox(height: 16),
              _buildLabel('Konfirmasi Password'),
              const SizedBox(height: 8),
              _buildTextField(controller: _confirmController, hint: 'Ulangi password', icon: Icons.lock_outline, obscure: _obscureConfirm, onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm)),
              if (_errorMsg != null) ...[const SizedBox(height: 12), Text(_errorMsg!, style: const TextStyle(color: Colors.red, fontSize: 13))],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Daftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF424242)));
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool obscure = false, VoidCallback? onToggle}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFBDBDBD)),
        suffixIcon: onToggle != null
            ? IconButton(icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFFBDBDBD)), onPressed: onToggle)
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
