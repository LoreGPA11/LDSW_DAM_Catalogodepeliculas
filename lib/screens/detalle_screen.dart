import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/firebase_service.dart';
import '../services/tmdb_service.dart';

class DetalleScreen extends StatefulWidget {
  final Movie movie;
  final FirebaseService firebase;
  final TmdbService? tmdb;

  const DetalleScreen({
    super.key,
    required this.movie,
    required this.firebase,
    this.tmdb,
  });

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  bool _isFav = false;
  bool _loadingDetails = false;
  String _director = '';
  String _genre = '';

  @override
  void initState() {
    super.initState();

    // Datos que ya vienen del modelo
    _director = widget.movie.director;
    _genre = widget.movie.genre;

    if (widget.movie.id != null) {
      widget.firebase.isFavorite(widget.movie.id!)
          .then((v) { if (mounted) setState(() => _isFav = v); });

      // Si es película de TMDB y faltan director/género, los buscamos
      if ((_director.isEmpty || _genre.isEmpty) && widget.tmdb != null) {
        _fetchDetails();
      }
    }
  }

  Future<void> _fetchDetails() async {
    if (widget.movie.id == null) return;
    setState(() => _loadingDetails = true);
    try {
      final details = await widget.tmdb!.getMovieDetails(widget.movie.id!);
      if (mounted) {
        setState(() {
          _director = widget.tmdb!.extractDirector(details);
          _genre = widget.tmdb!.extractGenres(details);
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingDetails = false);
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

    return Scaffold(
      backgroundColor: const Color(0xFF0D0000),
      body: CustomScrollView(
        slivers: [
          // ── Hero con poster ───────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Color(0xFFD4A017)),
            actions: [
              if (m.id != null)
                IconButton(
                  icon: Icon(
                    _isFav ? Icons.favorite : Icons.favorite_border,
                    color: _isFav ? const Color(0xFFD4A017) : Colors.white70,
                  ),
                  onPressed: _toggleFav,
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                m.posterUrl.isNotEmpty
                    ? Image.network(m.posterUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: const Color(0xFF1A0A00)))
                    : Container(color: const Color(0xFF1A0A00)),
                // Degradado
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xFF0D0000)],
                      stops: [0.55, 1.0],
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // ── Info ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(m.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      )),
                  const SizedBox(height: 10),

                  // Chips: año, calificación
                  Wrap(spacing: 8, children: [
                    if (m.year.isNotEmpty)
                      _Chip(icon: Icons.calendar_today_outlined, label: m.year),
                    if (m.voteAverage > 0)
                      _Chip(icon: Icons.star_outline, label: m.voteAverage.toStringAsFixed(1)),
                  ]),
                  const SizedBox(height: 18),

                  // Director
                  _loadingDetails
                      ? const _InfoSkeleton()
                      : _InfoRow(
                          icon: Icons.movie_creation_outlined,
                          label: 'Director',
                          value: _director.isNotEmpty ? _director : 'No disponible',
                        ),
                  const SizedBox(height: 10),

                  // Género
                  _loadingDetails
                      ? const _InfoSkeleton()
                      : _InfoRow(
                          icon: Icons.local_movies_outlined,
                          label: 'Género',
                          value: _genre.isNotEmpty ? _genre : 'No disponible',
                        ),
                  const SizedBox(height: 24),

                  // Sinopsis
                  const Text('Sinopsis',
                      style: TextStyle(
                        color: Color(0xFFD4A017),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    m.overview.isNotEmpty ? m.overview : 'Sin sinopsis disponible.',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.4)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: const Color(0xFFD4A017), size: 14),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ]),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: const Color(0xFFD4A017), size: 18),
      const SizedBox(width: 8),
      Expanded(child: RichText(text: TextSpan(
        children: [
          TextSpan(text: '$label: ',
              style: const TextStyle(color: Color(0xFFD4A017),
                  fontWeight: FontWeight.w600, fontSize: 13)),
          TextSpan(text: value,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ))),
    ],
  );
}

class _InfoSkeleton extends StatelessWidget {
  const _InfoSkeleton();
  @override
  Widget build(BuildContext context) => Container(
    height: 16, width: 180,
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}