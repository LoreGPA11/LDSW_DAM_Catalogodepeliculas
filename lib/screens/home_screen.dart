import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        // Fondo
        Image.network(
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1200',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(color: const Color(0xFF0D0000),
                child: const Center(child: CircularProgressIndicator(color: Color(0xFFD4A017))));
          },
          errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0D0000)),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.85),
              ],
            ),
          ),
        ),

        SafeArea(
          child: Column(children: [
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('LA BUTACA',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD4A017),
                        letterSpacing: 8,
                        shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 12)],
                      )),
                  const Icon(Icons.local_movies_outlined,
                      color: Color(0xFFD4A017), size: 30),
                ],
              ),
            ),

            const Spacer(),

            // Contenido central
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(children: [
                const Icon(Icons.theaters,
                    color: Color(0xFFD4A017), size: 90,
                    shadows: [Shadow(color: Color(0xFFFFD700), blurRadius: 24)]),
                const SizedBox(height: 28),
                const Text('Bienvenido',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 3))],
                    )),
                const SizedBox(height: 12),
                const Text('Tu cine favorito en la palma de tu mano',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFFD700),
                      letterSpacing: 1.5,
                    )),
                const SizedBox(height: 16),
                const Text(
                  'Descubre las últimas películas en cartelera, guarda tus favoritas y administra el catálogo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 48),

                // Botón principal
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen())),
                    icon: const Icon(Icons.login, color: Color(0xFF2B1000)),
                    label: const Text('INICIAR SESIÓN',
                        style: TextStyle(
                          color: Color(0xFF2B1000),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          fontSize: 15,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A017),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botón secundario
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                    icon: const Icon(Icons.person_add_outlined, color: Color(0xFFD4A017)),
                    label: const Text('CREAR CUENTA',
                        style: TextStyle(
                          color: Color(0xFFD4A017),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          fontSize: 15,
                        )),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD4A017), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ]),
            ),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text('La Butaca ${DateTime.now().year}',
                  style: const TextStyle(color: Colors.white30, fontSize: 12)),
            ),
          ]),
        ),
      ]),
    );
  }
}