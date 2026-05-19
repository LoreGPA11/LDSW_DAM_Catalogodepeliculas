import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../services/firebase_service.dart';
import 'detalle_screen.dart';
import 'admin_screen.dart';
import 'home_screen.dart';

class CarteleraScreen extends StatefulWidget {
  const CarteleraScreen({super.key});
  @override
  State<CarteleraScreen> createState() => _CarteleraScreenState();
}

class _CarteleraScreenState extends State<CarteleraScreen> {
  final _tmdb = TmdbService();
  final _firebase = FirebaseService();
  late Future<List<Movie>> _tmdbMovies;
  String _search = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tmdbMovies = _tmdb.getNowPlaying();
  }

  void _logout() async {
    await _firebase.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0000),

      // ── AppBar con menú ──────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('LA BUTACA',
            style: TextStyle(
              color: Color(0xFFD4A017),
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
              fontSize: 18,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined,
                color: Color(0xFFD4A017)),
            tooltip: 'Administración',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white54),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar película…',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4A017)),
                filled: true,
                fillColor: Colors.white10,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),

      // ── Tabs ─────────────────────────────────────────────────────────────
      body: Column(children: [
        // Tab selector
        Container(
          color: Colors.black,
          child: Row(children: [
            _TabBtn(label: 'En Cartelera', selected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0)),
            _TabBtn(label: 'Catálogo Admin', selected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1)),
          ]),
        ),

        Expanded(
          child: _selectedIndex == 0
              ? _TmdbGrid(future: _tmdbMovies, search: _search, firebase: _firebase, tmdb: _tmdb)
              : _CustomGrid(firebase: _firebase, search: _search),
        ),
      ]),
    );
  }
}

// ── TMDB Grid ─────────────────────────────────────────────────────────────────

class _TmdbGrid extends StatelessWidget {
  final Future<List<Movie>> future;
  final String search;
  final FirebaseService firebase;
  final TmdbService tmdb;

  const _TmdbGrid({required this.future, required this.search,
      required this.firebase, required this.tmdb});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFD4A017)));
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}',
              style: const TextStyle(color: Colors.white)));
        }
        final movies = snap.data!
            .where((m) => search.isEmpty || m.title.toLowerCase().contains(search))
            .toList();
        if (movies.isEmpty) {
          return const Center(child: Text('Sin resultados',
              style: TextStyle(color: Colors.white54)));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.6,
            crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: movies.length,
          itemBuilder: (ctx, i) =>
              _MovieCard(movie: movies[i], firebase: firebase, tmdb: tmdb),
        );
      },
    );
  }
}

// ── Custom (admin) Grid ───────────────────────────────────────────────────────

class _CustomGrid extends StatelessWidget {
  final FirebaseService firebase;
  final String search;

  const _CustomGrid({required this.firebase, required this.search});

  @override
  Widget build(BuildContext context) {
    // Espera a que haya usuario autenticado antes de escuchar Firestore
    if (firebase.currentUser == null) {
      return const Center(
        child: Text('Inicia sesión para ver el catálogo',
            style: TextStyle(color: Colors.white54)));
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firebase.customMoviesStream(),
      builder: (ctx, snap) {
        if (snap.hasError) {
          // Si es permission-denied, mostrar mensaje amigable
          final err = snap.error.toString();
          if (err.contains('permission-denied')) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Sin permisos de Firestore.\nVerifica las reglas en Firebase Console.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ),
            );
          }
          return Center(child: Text('Error: $err',
              style: const TextStyle(color: Colors.white54)));
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4A017)));
        }
        final data = (snap.data ?? [])
            .where((m) => search.isEmpty ||
                (m['title'] as String? ?? '').toLowerCase().contains(search))
            .toList();
        if (data.isEmpty) {
          return const Center(
              child: Text('No hay películas en el catálogo admin.\nAgrega desde Administración.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54)));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.6,
              crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: data.length,
          itemBuilder: (ctx, i) {
            final movie = Movie.fromFirestore(data[i], data[i]['docId'] ?? '');
            return _MovieCard(movie: movie, firebase: firebase, tmdb: null);
          },
        );
      },
    );
  }
}

// ── Movie Card ────────────────────────────────────────────────────────────────

class _MovieCard extends StatefulWidget {
  final Movie movie;
  final FirebaseService firebase;
  final TmdbService? tmdb;

  const _MovieCard({required this.movie, required this.firebase, this.tmdb});
  @override
  State<_MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<_MovieCard> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    if (widget.movie.id != null) {
      widget.firebase.isFavorite(widget.movie.id!)
          .then((v) { if (mounted) setState(() => _isFav = v); });
    }
  }

  void _toggleFav() async {
    if (widget.movie.id == null) return;
    if (_isFav) {
      await widget.firebase.removeFavorite(widget.movie.id!);
    } else {
      await widget.firebase.addFavorite(widget.movie);
    }
    if (mounted) setState(() => _isFav = !_isFav);
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.movie;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => DetalleScreen(movie: m, firebase: widget.firebase, tmdb: widget.tmdb))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(fit: StackFit.expand, children: [
          // Poster
          m.posterUrl.isNotEmpty
              ? Image.network(m.posterUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _Placeholder(m.title))
              : _Placeholder(m.title),

          // Gradiente inferior
          Positioned(bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(m.title,
                      style: const TextStyle(color: Colors.white,
                          fontSize: 13, fontWeight: FontWeight.w700),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (m.year.isNotEmpty)
                    Text(m.year,
                        style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            )),

          // Favorito
          if (m.id != null)
            Positioned(top: 8, right: 8,
              child: GestureDetector(
                onTap: _toggleFav,
                child: Icon(
                  _isFav ? Icons.favorite : Icons.favorite_border,
                  color: _isFav ? const Color(0xFFD4A017) : Colors.white70,
                  size: 26,
                ),
              )),
        ]),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF1A0A00),
    child: Center(child: Padding(
      padding: const EdgeInsets.all(8),
      child: Text(title, textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54, fontSize: 13)),
    )),
  );
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? const Color(0xFFD4A017) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? const Color(0xFFD4A017) : Colors.white38,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              fontSize: 13,
            )),
        ),
      ),
    );
  }
}