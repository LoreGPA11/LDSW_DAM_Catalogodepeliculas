import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // ── AUTH ──────────────────────────────────────────────────────────────────

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> register(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> login(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> logout() => _auth.signOut();

  // ── HELPERS ───────────────────────────────────────────────────────────────

  // Nunca usa ! — devuelve null si no hay sesión
  String? get _uid => _auth.currentUser?.uid;

  CollectionReference? get _favs {
    final uid = _uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('favorites');
  }

  CollectionReference get _customMovies => _db.collection('custom_movies');

  // ── FAVORITES ─────────────────────────────────────────────────────────────

  Future<void> addFavorite(Movie movie) async {
    final favs = _favs;
    if (favs == null) return;
    await favs.doc('${movie.id}').set(movie.toFirestore());
  }

  Future<void> removeFavorite(int movieId) async {
    final favs = _favs;
    if (favs == null) return;
    await favs.doc('$movieId').delete();
  }

  Future<bool> isFavorite(int movieId) async {
    final favs = _favs;
    if (favs == null) return false;   // sin sesión → no es favorito
    try {
      final doc = await favs.doc('$movieId').get();
      return doc.exists;
    } catch (_) {
      return false;
    }
  }

  Stream<List<int>> favoritesStream() {
    final favs = _favs;
    if (favs == null) return const Stream.empty();
    return favs.snapshots().map(
      (snap) => snap.docs
          .map((d) => (d.data() as Map<String, dynamic>)['id'] as int? ?? 0)
          .toList(),
    );
  }

  // ── CUSTOM MOVIES (admin) ─────────────────────────────────────────────────

  Future<void> addCustomMovie(Movie movie) async {
    if (_uid == null) return;
    await _customMovies.add(movie.toFirestore());
  }

  Future<void> deleteCustomMovie(String docId) async {
    if (_uid == null) return;
    await _customMovies.doc(docId).delete();
  }

  Stream<List<Map<String, dynamic>>> customMoviesStream() {
    if (_uid == null) return const Stream.empty();  // sin sesión → stream vacío
    return _customMovies.orderBy('addedAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((d) => {
                    ...d.data() as Map<String, dynamic>,
                    'docId': d.id,
                  })
              .toList(),
        );
  }

  Future<List<Map<String, dynamic>>> getCustomMovies() async {
    if (_uid == null) return [];
    final snap = await _customMovies.orderBy('addedAt', descending: true).get();
    return snap.docs
        .map((d) => {...d.data() as Map<String, dynamic>, 'docId': d.id})
        .toList();
  }
}