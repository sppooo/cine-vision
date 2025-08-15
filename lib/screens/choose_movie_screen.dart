import 'dart:math';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_details_screen.dart';

class ChooseMovieScreen extends StatelessWidget {
  final String mood;

  ChooseMovieScreen({required this.mood});

  final List<Movie> allMovies = [
    Movie(
      title: 'Fast & Furious',
      description: 'Dominic Toretto and his crew race through thrilling high-octane missions.',
      posterPath: 'assets/movies/ff.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=ZsJz2TJAPjw',
    ),
    Movie(
      title: 'Jersey',
      description: 'A failed cricketer fights odds to fulfill his son’s wish of a jersey.',
      posterPath: 'assets/movies/jersey.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=AjAe_Q1WZ_8',
    ),
    Movie(
      title: 'Formula 1',
      description: 'A gripping documentary diving into the world of elite motorsport racing.',
      posterPath: 'assets/movies/f1.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=CT2_P2DZBR0',
    ),
    Movie(
      title: 'Khaleja',
      description: 'A taxi driver becomes the unlikely savior of a remote village.',
      posterPath: 'assets/movies/khaleja.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=YraH4F8SdU0',
    ),
    Movie(
      title: 'Sita Ramam',
      description: 'A beautiful love story unfolds through letters lost and found.',
      posterPath: 'assets/movies/sr.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=Ljk6tGZ1l3A',
    ),
    Movie(
      title: 'Attarintiki Daredi',
      description: 'A man attempts to reconcile his uncle with his estranged daughter.',
      posterPath: 'assets/movies/ad.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=YDtHhh3JjXY',
    ),
    Movie(
      title: 'Aashiqui 2',
      description: 'A tragic musical romance between a fading singer and his protégé.',
      posterPath: 'assets/movies/aa.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=FyXXgpPqe6w',
    ),
    Movie(
      title: '2 States',
      description: 'A couple from different cultures fights to marry against family odds.',
      posterPath: 'assets/movies/2.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=CGyAaR2aWcA',
    ),
    Movie(
      title: 'Avatar',
      description: 'A marine on an alien planet must choose between duty and a new world.',
      posterPath: 'assets/movies/avatar.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=d9MyW72ELq0',
    ),
    Movie(
      title: 'Doctor Strange',
      description: 'A surgeon discovers mystic arts after a tragic accident changes his life.',
      posterPath: 'assets/movies/doctor_strange.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=aWzlQ2N6qqg',
    ),
    Movie(
      title: 'Hi Nanna',
      description: 'An emotional story of a father and daughter discovering their past.',
      posterPath: 'assets/movies/hi_nanna.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=Iz97_kxHaSc',
    ),
    Movie(
      title: 'Batman',
      description: 'The caped crusader returns to fight crime in Gotham City.',
      posterPath: 'assets/movies/batman.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=mqqft2x_Aa4',
    ),
    Movie(
      title: 'Yeh Jawaani Hai Deewani',
      description: 'A vibrant tale of friendship, travel, and young love.',
      posterPath: 'assets/movies/yeh_jawaani_hai_deewani.jpg',
      trailerUrl: 'https://www.youtube.com/watch?v=Rbp2XUSeUNE',
    ),
  ];

  final List<String> userNames = [
    'Aarav', 'Meera', 'Vivaan', 'Ananya', 'Raj', 'Sneha', 'Ishaan', 'Diya', 'Rohan', 'Tanya'
  ];

  final List<String> reviewTexts = [
    'Amazing movie! Totally worth watching.',
    'Great performances and stunning visuals!',
    'Loved the storyline and the direction.',
    'One of the best movies I’ve seen this year.',
    'Emotional and powerful. Must watch!',
  ];

  List<Movie> filterByMood(String mood) {
    final lowerMood = mood.toLowerCase();

    if (lowerMood.contains('action')) {
      return allMovies.where((m) => m.title.contains('Fast') || m.title.contains('Batman') || m.title.contains('Doctor')).toList();
    } else if (lowerMood.contains('romantic')) {
      return allMovies.where((m) => m.title.contains('Sita') || m.title.contains('Aashiqui') || m.title.contains('2 States')).toList();
    } else if (lowerMood.contains('family')) {
      return allMovies.where((m) => m.title.contains('Attarintiki') || m.title.contains('Khaleja')).toList();
    } else if (lowerMood.contains('drama')) {
      return allMovies.where((m) => m.title.contains('Jersey') || m.title.contains('Hi Nanna')).toList();
    } else if (lowerMood.contains('sci-fi')) {
      return allMovies.where((m) => m.title.contains('Avatar') || m.title.contains('Doctor')).toList();
    }

    return allMovies;
  }

  Widget buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget buildReviewBox(String user, String review, int rating) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(review, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 4),
          buildStarRating(rating),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = filterByMood(mood);
    final random = Random();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text('Mood: $mood'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: filteredMovies.isEmpty
          ? Center(child: Text('No movies found for this mood.', style: TextStyle(color: Colors.deepOrange[200])))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: filteredMovies.length,
          itemBuilder: (context, index) {
            final movie = filteredMovies[index];
            final randomUser = userNames[random.nextInt(userNames.length)];
            final randomReview = reviewTexts[random.nextInt(reviewTexts.length)];
            final randomRating = random.nextInt(3) + 3; // 3 to 5 stars

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(movie.posterPath, width: double.infinity, height: 180, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildReviewBox(randomUser, randomReview, randomRating),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
