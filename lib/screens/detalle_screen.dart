import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';
import '../services/firebase_service.dart';

class DetalleScreen extends StatelessWidget {
  final Movie movie;
  final FirebaseService firebase;
  const DetalleScreen({super.key, required this.movie, required this.firebase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0000),
      body: CustomScrollView(slivers: [
        SliverAppBar(expandedHeight: 400, pinned: true,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(movie.posterUrl, fit: BoxFit.cover))),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(movie.title, style: const TextStyle(color: Color(0xFFD4A017),
              fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.star, color: Color(0xFFD4A017), size: 18),
              const SizedBox(width: 4),
              Text(movie.voteAverage.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white70)),
              const SizedBox(width: 16),
              Text(movie.releaseDate, style: const TextStyle(color: Colors.white54)),
            ]),
            const SizedBox(height: 16),
            Text(movie.overview, style: const TextStyle(color: Colors.white70, height: 1.5)),
            const SizedBox(height: 32),
            // Vista de datos de Firebase (tus favoritos guardados)
            const Text('Otros favoritos en la app',
              style: TextStyle(color: Color(0xFFD4A017), fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: firebase.watchFavorites(),
              builder: (ctx, snap) {
                if (!snap.hasData) return const CircularProgressIndicator(color: Color(0xFFD4A017));
                final docs = snap.data!.docs.take(5).toList();
                return Column(children: docs.map((d) {
                  final data = d.data() as Map<String, dynamic>;
                  return ListTile(contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w92${data['posterPath']}',
                        width: 40, height: 60, fit: BoxFit.cover)),
                    title: Text(data['title'] ?? '', style: const TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.favorite, color: Color(0xFFD4A017), size: 18));
                }).toList());
              }),
          ]))),
      ]),
    );
  }
}