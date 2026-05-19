import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbService {
  // ⚠️  Reemplaza con tu API key de TMDB (https://www.themoviedb.org/settings/api)
  static const _apiKey = '7d9fa06dbcb0ce56d410946bad938afc';
  static const _base = 'https://api.themoviedb.org/3';
  static const _lang = 'es-MX';

  Future<List<Movie>> getNowPlaying() async {
    final uri = Uri.parse('$_base/movie/now_playing?api_key=$_apiKey&language=$_lang&page=1');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('TMDB error ${res.statusCode}');
    final data = jsonDecode(res.body);
    final results = data['results'] as List;
    return results.map((j) => Movie.fromJson(j)).toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    final uri = Uri.parse(
        '$_base/search/movie?api_key=$_apiKey&language=$_lang&query=${Uri.encodeComponent(query)}');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('TMDB error ${res.statusCode}');
    final data = jsonDecode(res.body);
    final results = data['results'] as List;
    return results.map((j) => Movie.fromJson(j)).toList();
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final uri = Uri.parse(
        '$_base/movie/$movieId?api_key=$_apiKey&language=$_lang&append_to_response=credits');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('TMDB error ${res.statusCode}');
    return jsonDecode(res.body);
  }

  /// Extrae el nombre del director desde los créditos de TMDB
  String extractDirector(Map<String, dynamic> details) {
    final crew = details['credits']?['crew'] as List? ?? [];
    final director = crew.firstWhere(
      (p) => p['job'] == 'Director',
      orElse: () => {'name': 'Desconocido'},
    );
    return director['name'] ?? 'Desconocido';
  }

  /// Extrae géneros como string separado por comas
  String extractGenres(Map<String, dynamic> details) {
    final genres = details['genres'] as List? ?? [];
    return genres.map((g) => g['name']).join(', ');
  }
}