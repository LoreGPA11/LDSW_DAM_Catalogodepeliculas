import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;
  // Colección de favoritos (puedes agregar userId si implementas Auth)
  CollectionReference get _favs => _db.collection('favoritos');

  Future<void> addFavorite(Movie movie) =>
      _favs.doc(movie.id.toString()).set(movie.toFirestore());

  Future<void> removeFavorite(int movieId) =>
      _favs.doc(movieId.toString()).delete();

  Stream<QuerySnapshot> watchFavorites() => _favs.orderBy('addedAt', descending: true).snapshots();

  Future<bool> isFavorite(int movieId) async {
    final doc = await _favs.doc(movieId.toString()).get();
    return doc.exists;
  }
}