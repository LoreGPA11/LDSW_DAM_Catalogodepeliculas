import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/firebase_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _firebase = FirebaseService();

  // Formulario
  final _titleCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _directorCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();
  final _synopsisCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _yearCtrl.dispose();
    _directorCtrl.dispose();
    _genreCtrl.dispose();
    _synopsisCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  void _clearForm() {
    _titleCtrl.clear();
    _yearCtrl.clear();
    _directorCtrl.clear();
    _genreCtrl.clear();
    _synopsisCtrl.clear();
    _imageCtrl.clear();
  }

  Future<void> _addMovie() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _error = 'El título es obligatorio');
      return;
    }
    setState(() { _saving = true; _error = null; });
    try {
      final movie = Movie(
        title: _titleCtrl.text.trim(),
        overview: _synopsisCtrl.text.trim(),
        posterPath: _imageCtrl.text.trim(),
        voteAverage: 0,
        releaseDate: _yearCtrl.text.trim(),
        director: _directorCtrl.text.trim(),
        genre: _genreCtrl.text.trim(),
        isCustom: true,
      );
      await _firebase.addCustomMovie(movie);
      _clearForm();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Película agregada al catálogo'),
              backgroundColor: Color(0xFF2D7A2D)));
      }
    } catch (e) {
      setState(() => _error = 'Error al guardar: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteMovie(String docId, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A0A00),
        title: const Text('Eliminar película',
            style: TextStyle(color: Color(0xFFD4A017))),
        content: Text('¿Eliminar "$title" del catálogo?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _firebase.deleteCustomMovie(docId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🗑️ Película eliminada'),
            backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0000),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFD4A017)),
        title: const Text('ADMINISTRACIÓN',
            style: TextStyle(
              color: Color(0xFFD4A017),
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              fontSize: 16,
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Formulario de alta ─────────────────────────────────────────
          const Text('AGREGAR PELÍCULA',
              style: TextStyle(
                color: Color(0xFFD4A017),
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                fontSize: 13,
              )),
          const SizedBox(height: 16),

          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ),
            const SizedBox(height: 12),
          ],

          _Field(controller: _titleCtrl, label: 'Título *',
              icon: Icons.movie_outlined),
          const SizedBox(height: 12),
          _Field(controller: _yearCtrl, label: 'Año',
              icon: Icons.calendar_today_outlined,
              keyboard: TextInputType.number),
          const SizedBox(height: 12),
          _Field(controller: _directorCtrl, label: 'Director',
              icon: Icons.movie_creation_outlined),
          const SizedBox(height: 12),
          _Field(controller: _genreCtrl, label: 'Género',
              icon: Icons.local_movies_outlined),
          const SizedBox(height: 12),
          _Field(controller: _synopsisCtrl, label: 'Sinopsis',
              icon: Icons.description_outlined, maxLines: 4),
          const SizedBox(height: 12),
          _Field(controller: _imageCtrl, label: 'URL de imagen (poster)',
              icon: Icons.image_outlined),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _addMovie,
              icon: _saving
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2B1000)))
                  : const Icon(Icons.add_circle_outline, color: Color(0xFF2B1000)),
              label: Text(_saving ? 'GUARDANDO…' : 'AGREGAR AL CATÁLOGO',
                  style: const TextStyle(
                    color: Color(0xFF2B1000),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  )),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A017),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const SizedBox(height: 36),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),

          // ── Lista de películas del catálogo admin ──────────────────────
          const Text('CATÁLOGO ACTUAL',
              style: TextStyle(
                color: Color(0xFFD4A017),
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                fontSize: 13,
              )),
          const SizedBox(height: 12),

          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _firebase.customMoviesStream(),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4A017)));
              }
              final list = snap.data ?? [];
              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('El catálogo está vacío.',
                      style: TextStyle(color: Colors.white38))),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final item = list[i];
                  final docId = item['docId'] as String? ?? '';
                  final title = item['title'] as String? ?? '';
                  final year = item['releaseDate'] as String? ?? '';
                  final director = item['director'] as String? ?? '';
                  final posterPath = item['posterPath'] as String? ?? '';
                  final posterUrl = posterPath.startsWith('http')
                      ? posterPath
                      : posterPath.isNotEmpty
                          ? 'https://image.tmdb.org/t/p/w500$posterPath'
                          : '';

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: posterUrl.isNotEmpty
                            ? Image.network(posterUrl,
                                width: 48, height: 68, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const _PosterPlaceholder())
                            : const _PosterPlaceholder(),
                      ),
                      title: Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (year.isNotEmpty)
                            Text(year,
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 12)),
                          if (director.isNotEmpty)
                            Text(director,
                                style: const TextStyle(
                                    color: Color(0xFFD4A017), fontSize: 12)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 22),
                        onPressed: () => _deleteMovie(docId, title),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ]),
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final int maxLines;
  final TextInputType keyboard;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.maxLines = 1,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFFD4A017), size: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD4A017)),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder();
  @override
  Widget build(BuildContext context) => Container(
    width: 48, height: 68,
    color: const Color(0xFF1A0A00),
    child: const Icon(Icons.image_not_supported_outlined,
        color: Colors.white24, size: 20),
  );
}