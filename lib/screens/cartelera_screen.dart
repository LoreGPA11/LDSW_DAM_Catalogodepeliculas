import 'package:flutter/material.dart';
import 'package:flutter_app_1/screens/detalle_screen.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../services/firebase_service.dart';

class CarteleraScreen extends StatefulWidget {
  const CarteleraScreen({super.key});
  @override State<CarteleraScreen> createState() => _CarteleraScreenState();
}

class _CarteleraScreenState extends State<CarteleraScreen> {
  final _tmdb = TmdbService();
  final _firebase = FirebaseService();
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = _tmdb.getNowPlaying();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0000),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('CARTELERA', style: TextStyle(
          color: Color(0xFFD4A017), fontWeight: FontWeight.w900, letterSpacing: 6)),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD4A017)));
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}', style: const TextStyle(color: Colors.white)));
          }
          final movies = snap.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.6, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: movies.length,
            itemBuilder: (ctx, i) => _MovieCard(movie: movies[i], firebase: _firebase),
          );
        },
      ),
    );
  }
}

class _MovieCard extends StatefulWidget {
  final Movie movie;
  final FirebaseService firebase;
  const _MovieCard({required this.movie, required this.firebase});
  @override State<_MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<_MovieCard> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    widget.firebase.isFavorite(widget.movie.id).then((v) => setState(() => _isFav = v));
  }

  void _toggleFav() async {
    if (_isFav) {
      await widget.firebase.removeFavorite(widget.movie.id);
    } else {
      await widget.firebase.addFavorite(widget.movie);
    }
    setState(() => _isFav = !_isFav);
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.movie;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => DetalleScreen(movie: m, firebase: widget.firebase))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(fit: StackFit.expand, children: [
          Image.network(m.posterUrl, fit: BoxFit.cover),
          Positioned(bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87])),
              child: Text(m.title, style: const TextStyle(color: Colors.white,
                fontSize: 13, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
            )),
          Positioned(top: 8, right: 8,
            child: GestureDetector(onTap: _toggleFav,
              child: Icon(_isFav ? Icons.favorite : Icons.favorite_border,
                color: _isFav ? const Color(0xFFD4A017) : Colors.white70, size: 26))),
        ]),
      ),
    );
  }
}