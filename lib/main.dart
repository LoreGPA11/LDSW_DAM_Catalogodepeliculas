import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/cartelera_screen.dart';
import 'services/firebase_service.dart' hide FirebaseService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class DefaultFirebaseOptions {
  static FirebaseOptions? get currentPlatform => null;
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4A017),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0000),
      ),
      home: const _AuthGate(),
    );
  }
}

/// Redirige al usuario según su estado de autenticación:
/// - Si hay sesión activa → Cartelera
/// - Si no → Pantalla de inicio (Bienvenida) algo sale mal aquí... sino se autentifica un usuario, se detiene la app
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseService();
    return StreamBuilder(
      stream: firebase.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D0000),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFD4A017)),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const CarteleraScreen();
        }
        return const HomeScreen();
      },
    );
  }
}