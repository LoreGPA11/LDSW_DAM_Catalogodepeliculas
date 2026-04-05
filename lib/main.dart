import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Butaca',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900),
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── PANTALLA DE BIENVENIDA ───────────────────────────────────────────────────

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo degradado oscuro
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF3B1A0A),
                  Color(0xFF1A0000),
                  Color(0xFF0D0000),
                ],
              ),
            ),
          ),

          // Cortinas izquierda y derecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CurtainPanel(isLeft: true),
              _CurtainPanel(isLeft: false),
            ],
          ),

          // Contenido central
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.videocam,
                color: Color(0xFFD4A017),
                size: 72,
                shadows: [
                  Shadow(color: Color(0xFFFFD700), blurRadius: 30),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'BIENVENIDO',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFD4A017),
                  letterSpacing: 10,
                  shadows: [
                    Shadow(
                      color: Color(0xFFFFD700),
                      blurRadius: 15,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Ticket CINEMA
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB8860B),
                      Color(0xFFFFD700),
                      Color(0xFFDAA520),
                      Color(0xFFB8860B),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5), // ✅ corregido
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TicketEdge(),
                    const SizedBox(width: 16),
                    const Text(
                      'LA BUTACA',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF4A2800),
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _TicketEdge(),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A017),
                  foregroundColor: const Color(0xFF2B1000),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 48, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'INGRESAR',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          // Estrella decorativa ✅ ícono corregido
          const Positioned(
            bottom: 20,
            right: 20,
            child: Icon(Icons.auto_awesome, color: Colors.white54, size: 24),
          ),
        ],
      ),
    );
  }
}

// ─── PANTALLA DE LOGIN ────────────────────────────────────────────────────────

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo oscuro
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF3B1A0A),
                  Color(0xFF1A0000),
                  Color(0xFF0D0000),
                ],
              ),
            ),
          ),

          // Cortinas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CurtainPanel(isLeft: true),
              _CurtainPanel(isLeft: false),
            ],
          ),

          Column(
            children: [
              const SizedBox(height: 60),

              // Título + ícono perfil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    const Text(
                      'LA BUTACA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD4A017),
                        letterSpacing: 8,
                        shadows: [
                          Shadow(color: Color(0xFFFFD700), blurRadius: 12),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFD4A017), width: 1.5),
                      ),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.person_outline,
                            color: Color(0xFFD4A017), size: 22),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Tarjeta de login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12), // ✅ corregido
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2), // ✅ corregido
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4), // ✅ corregido
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _LoginLabel('Nombre de Usuario'),
                      const SizedBox(height: 6),
                      const _LoginField(hint: 'Nombre de Usuario'),
                      const SizedBox(height: 16),
                      const _LoginLabel('Correo Electrónico'),
                      const SizedBox(height: 6),
                      const _LoginField(hint: 'Correo Electrónico'),
                      const SizedBox(height: 16),
                      const _LoginLabel('Contraseña'),
                      const SizedBox(height: 6),
                      const _LoginField(hint: 'Contraseña', obscureText: true),
                      const SizedBox(height: 24),

                      // Botón INGRESAR dorado
                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFB8860B),
                                Color(0xFFFFD700),
                                Color(0xFFDAA520),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700)
                                    .withValues(alpha: 0.3), // ✅ corregido
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'INGRESAR',
                              style: TextStyle(
                                color: Color(0xFF2B1000),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Column(
                        children: [
                          Center(
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8), // ✅ corregido
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Regístrate aquí',
                              style: TextStyle(
                                color: Color(0xFFD4A017),
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFD4A017),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),

          // Estrella decorativa ✅ ícono corregido
          const Positioned(
            bottom: 20,
            right: 20,
            child: Icon(Icons.auto_awesome, color: Colors.white54, size: 24),
          ),
        ],
      ),
    );
  }
}

// ─── WIDGETS AUXILIARES ───────────────────────────────────────────────────────

class _CurtainPanel extends StatelessWidget {
  final bool isLeft;
  const _CurtainPanel({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isLeft ? Alignment.centerRight : Alignment.centerLeft,
          end: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          colors: const [
            Color(0xFF8B0000),
            Color(0xFF5C0000),
            Color(0xFF3B0000),
          ],
        ),
      ),
      child: Stack(
        children: List.generate(
          5,
          (i) => Positioned(
            left: isLeft ? null : (i * 16.0),
            right: isLeft ? (i * 16.0) : null,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3), // ✅ corregido
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2), // ✅ corregido
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketEdge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (_) => Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF4A2800),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _LoginLabel extends StatelessWidget {
  final String text;
  const _LoginLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  const _LoginField({required this.hint, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.5)), // ✅ corregido
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15), // ✅ corregido
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.2)), // ✅ corregido
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.2)), // ✅ corregido
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Color(0xFFD4A017), width: 1.5),
        ),
      ),
    );
  }
}