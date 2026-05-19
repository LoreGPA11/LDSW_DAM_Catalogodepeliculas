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

  String get _uid => _auth.currentUser!.uid;

  CollectionReference get _favs =>
      _db.collection('users').doc(_uid).collection('favorites');

  CollectionReference get _customMovies =>
      _db.collection('custom_movies');

  // ── FAVORITES ─────────────────────────────────────────────────────────────

  Future<void> addFavorite(Movie movie) =>
      _favs.doc('${movie.id}').set(movie.toFirestore());

  Future<void> removeFavorite(int movieId) =>
      _favs.doc('$movieId').delete();

  Future<bool> isFavorite(int movieId) async {
    final doc = await _favs.doc('$movieId').get();
    return doc.exists;
  }

  Stream<List<int>> favoritesStream() => _favs.snapshots().map(
        (snap) => snap.docs
            .map((d) => (d.data() as Map<String, dynamic>)['id'] as int? ?? 0)
            .toList(),
      );

  // ── CUSTOM MOVIES (admin) ─────────────────────────────────────────────────

  Future<void> addCustomMovie(Movie movie) async {
    await _customMovies.add(movie.toFirestore());
  }

  Future<void> deleteCustomMovie(String docId) async {
    await _customMovies.doc(docId).delete();
  }

  Stream<List<Map<String, dynamic>>> customMoviesStream() =>
      _customMovies.orderBy('addedAt', descending: true).snapshots().map(
            (snap) => snap.docs
                .map((d) => {
                      ...d.data() as Map<String, dynamic>,
                      'docId': d.id,
                    })
                .toList(),
          );

  Future<List<Map<String, dynamic>>> getCustomMovies() async {
    final snap = await _customMovies.orderBy('addedAt', descending: true).get();
    return snap.docs.map((d) => {...d.data() as Map<String, dynamic>, 'docId': d.id}).toList();
  }
}