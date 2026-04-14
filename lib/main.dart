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
      home: const HomeScreen(),
    );
  }
}

// ─── HOME SCREEN ──────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          // ── 1. IMAGE — imagen de fondo ────────────────────────────────────
          Image.network(
            'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1200',
            fit: BoxFit.cover,
            // Mientras carga, muestra el fondo oscuro de la app
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
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
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD4A017),
                  ),
                ),
              );
            },
          ),

          // Capa de oscurecimiento sobre la imagen
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),

          // ── Contenido principal ───────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [

                // ── AppBar manual con nombre de la app e ícono ────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nombre de la aplicación
                      const Text(
                        'LA BUTACA',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFD4A017),
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: Color(0xFFFFD700),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),

                      // ── ICON — ícono de perfil ───────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD4A017),
                            width: 1.5,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.person_outline,
                            color: Color(0xFFD4A017),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Bloque central con saludo ─────────────────────────────
                Column(
                  children: [
                    // ── ICON — ícono decorativo central ──────────────────
                    const Icon(
                      Icons.local_movies_outlined,
                      color: Color(0xFFD4A017),
                      size: 80,
                      shadows: [
                        Shadow(
                          color: Color(0xFFFFD700),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── TEXT — mensaje de bienvenida ──────────────────────
                    const Text(
                      'Hello World',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtítulo de bienvenida
                    const Text(
                      'Bienvenido a tu cine favorito',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFD700),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Botón para entrar
                    ElevatedButton.icon(
                      onPressed: () {},
                      // ── ICON — ícono dentro del botón ────────────────
                      icon: const Icon(
                        Icons.play_circle_outline,
                        color: Color(0xFF2B1000),
                        size: 22,
                      ),
                      label: const Text(
                        'EXPLORAR',
                        style: TextStyle(
                          color: Color(0xFF2B1000),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A017),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // ── Barra inferior con íconos de navegación ───────────────
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFD4A017).withValues(alpha: 0.4),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      // ── ICON x4 — barra de navegación ────────────────
                      _NavIcon(icon: Icons.home_outlined,     label: 'Inicio',    active: true),
                      _NavIcon(icon: Icons.movie_outlined,    label: 'Cartelera', active: false),
                      _NavIcon(icon: Icons.confirmation_num_outlined, label: 'Tickets', active: false),
                      _NavIcon(icon: Icons.settings_outlined, label: 'Ajustes',   active: false),
                    ],
                  ),
                ),

              ],
            ),
          ),

          // Estrella decorativa
          const Positioned(
            bottom: 80,
            right: 20,
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white30,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── WIDGET AUXILIAR — ítem de navegación ─────────────────────────────────────

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFFD4A017) : Colors.white54;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── ICON — ítem individual de navegación ─────────────────────────
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}