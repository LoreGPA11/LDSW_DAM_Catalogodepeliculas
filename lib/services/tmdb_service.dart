import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbService {
  static const _apiKey = '7d9fa06dbcb0ce56d410946bad938afc'; // ← de themoviedb.org > Settings > API
  static const _base   = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getNowPlaying() async {
    final uri = Uri.parse('$_base/movie/now_playing?api_key=$_apiKey&language=es-MX');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Error TMDB: ${res.statusCode}');
    final data = jsonDecode(res.body);
    return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
  }

  Future<List<Movie>> getPopular() async {
    final uri = Uri.parse('$_base/movie/popular?api_key=$_apiKey&language=es-MX');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Error TMDB: ${res.statusCode}');
    final data = jsonDecode(res.body);
    return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
  }
}