import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'cartelera_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _firebase = FirebaseService();

  // Login
  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();

  // Register
  final _regEmailCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regPass2Ctrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPassCtrl.dispose();
    _regPass2Ctrl.dispose();
    super.dispose();
  }

  void _showError(String msg) => setState(() => _error = msg);

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    try {
      await _firebase.login(_loginEmailCtrl.text.trim(), _loginPassCtrl.text.trim());
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const CarteleraScreen()));
    } catch (e) {
      _showError('Error al iniciar sesión: ${_friendlyError(e.toString())}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _register() async {
    if (_regPassCtrl.text != _regPass2Ctrl.text) {
      _showError('Las contraseñas no coinciden');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await _firebase.register(_regEmailCtrl.text.trim(), _regPassCtrl.text.trim());
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const CarteleraScreen()));
    } catch (e) {
      _showError('Error al registrarse: ${_friendlyError(e.toString())}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String e) {
    if (e.contains('user-not-found') || e.contains('wrong-password')) {
      return 'Correo o contraseña incorrectos';
    }
    if (e.contains('email-already-in-use')) return 'El correo ya está registrado';
    if (e.contains('weak-password')) return 'La contraseña es muy débil (mínimo 6 caracteres)';
    if (e.contains('invalid-email')) return 'Correo no válido';
    return e;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        // Fondo
        Image.network(
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1200',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0D0000)),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.5),
                Colors.black.withValues(alpha: 0.9),
              ],
            ),
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(children: [
              const SizedBox(height: 48),

              // Logo
              const Text('LA BUTACA',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFD4A017),
                    letterSpacing: 8,
                  )),
              const SizedBox(height: 6),
              const Text('Tu cine favorito',
                  style: TextStyle(color: Colors.white54, letterSpacing: 2)),
              const SizedBox(height: 40),

              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFFD4A017),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: const Color(0xFF2B1000),
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                  tabs: const [
                    Tab(text: 'INICIAR SESIÓN'),
                    Tab(text: 'REGISTRARSE'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Error
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
              if (_error != null) const SizedBox(height: 16),

              SizedBox(
                height: 340,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ── LOGIN ──
                    Column(children: [
                      _Field(controller: _loginEmailCtrl, label: 'Correo electrónico',
                          icon: Icons.email_outlined, keyboard: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _Field(controller: _loginPassCtrl, label: 'Contraseña',
                          icon: Icons.lock_outline, obscure: true),
                      const SizedBox(height: 28),
                      _GoldButton(
                        label: 'ENTRAR',
                        loading: _loading,
                        onPressed: _login,
                      ),
                    ]),

                    // ── REGISTER ──
                    Column(children: [
                      _Field(controller: _regEmailCtrl, label: 'Correo electrónico',
                          icon: Icons.email_outlined, keyboard: TextInputType.emailAddress),
                      const SizedBox(height: 14),
                      _Field(controller: _regPassCtrl, label: 'Contraseña',
                          icon: Icons.lock_outline, obscure: true),
                      const SizedBox(height: 14),
                      _Field(controller: _regPass2Ctrl, label: 'Confirmar contraseña',
                          icon: Icons.lock_outline, obscure: true),
                      const SizedBox(height: 24),
                      _GoldButton(
                        label: 'CREAR CUENTA',
                        loading: _loading,
                        onPressed: _register,
                      ),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboard;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: const Color(0xFFD4A017)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD4A017)),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white10,
      ),
    );
  }
}

class _GoldButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _GoldButton({required this.label, required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4A017),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: loading
            ? const SizedBox(height: 20, width: 20,
                child: CircularProgressIndicator(color: Color(0xFF2B1000), strokeWidth: 2))
            : Text(label,
                style: const TextStyle(
                  color: Color(0xFF2B1000),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                )),
      ),
    );
  }
}