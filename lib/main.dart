import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/cartelera_screen.dart';

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

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // authStateChanges emite null mientras carga, luego User o null
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mientras Firebase Auth no ha resuelto el estado → spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D0000),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFD4A017)),
            ),
          );
        }
        // Auth resuelto: hay usuario → Cartelera, no hay → Home
        if (snapshot.hasData && snapshot.data != null) {
          return const CarteleraScreen();
        }
        return const HomeScreen();
      },
    );
  }
}