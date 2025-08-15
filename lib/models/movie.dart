class Movie {
  final String title;
  final String description;
  final String posterPath;
  final double rating;
  final List<String> reviews;
  final String trailerUrl;

  Movie({
    required this.title,
    required this.description,
    required this.posterPath,
    this.rating = 4.0,
    this.reviews = const [],
    required this.trailerUrl,
  });
}
