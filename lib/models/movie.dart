class Movie {
  final int? id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final String director;
  final String genre;
  final bool isCustom; // true = ingresada manualmente por admin

  Movie({
    this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    this.director = '',
    this.genre = '',
    this.isCustom = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'],
        title: json['title'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'] ?? '',
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
        releaseDate: json['release_date'] ?? '',
        director: json['director'] ?? '',
        genre: json['genre'] ?? '',
        isCustom: json['isCustom'] ?? false,
      );

  factory Movie.fromFirestore(Map<String, dynamic> data, String docId) => Movie(
        id: data['id'],
        title: data['title'] ?? '',
        overview: data['overview'] ?? '',
        posterPath: data['posterPath'] ?? '',
        voteAverage: (data['voteAverage'] ?? 0).toDouble(),
        releaseDate: data['releaseDate'] ?? '',
        director: data['director'] ?? '',
        genre: data['genre'] ?? '',
        isCustom: data['isCustom'] ?? false,
      );

  String get posterUrl => posterPath.startsWith('http')
      ? posterPath
      : posterPath.isNotEmpty
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : '';

  String get year => releaseDate.length >= 4 ? releaseDate.substring(0, 4) : releaseDate;

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'title': title,
        'overview': overview,
        'posterPath': posterPath,
        'voteAverage': voteAverage,
        'releaseDate': releaseDate,
        'director': director,
        'genre': genre,
        'isCustom': isCustom,
        'addedAt': DateTime.now().toIso8601String(),
      };
}