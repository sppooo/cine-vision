import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  String searchQuery = '';
  bool _showChatBox = false;
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  bool isCineBotExpanded = false;
  String cineBotResponse = '';
  String userQuery = '';
  late stt.SpeechToText _speech;
  bool _isListening = false;
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) => setState(() => _isListening = false),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              userQuery = val.recognizedWords;
              cineBotResponse = getCineBotResponse(userQuery);
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
  Widget _buildExpandedCineBot() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 320,
        height: 400,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.android, color: Colors.deepOrangeAccent),
                const SizedBox(width: 8),
                const Text("CineBot", style: TextStyle(fontSize: 18, color: Colors.deepOrangeAccent)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => setState(() => isCineBotExpanded = false),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userQuery.isNotEmpty) ...[
                      Text("You: $userQuery", style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 10),
                    ],
                    if (cineBotResponse.isNotEmpty)
                      Text("CineBot: $cineBotResponse", style: const TextStyle(color: Colors.deepOrangeAccent)),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Ask CineBot...',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        userQuery = value;
                        cineBotResponse = getCineBotResponse(value);
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.deepOrangeAccent),
                  onPressed: _listen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getCineBotResponse(String query) {
    query = query.toLowerCase();

    if (query.contains('recommend') || query.contains('suggest')) {
      return "I recommend watching *Interstellar* if you like sci-fi, or *La La Land* for romance!";
    } else if (query.contains('timing') || query.contains('show')) {
      return "Movie shows are available from 10 AM to 11 PM. Please select your preferred timing on the booking screen.";
    } else if (query.contains('price') || query.contains('ticket')) {
      return "Ticket prices range from ₹150 to ₹400 depending on seat type and movie.";
    } else if (query.contains('offer') || query.contains('discount')) {
      return "You can apply coupons or use CineWallet for discounts during payment.";
    } else if (query.contains('hi') || query.contains('hello')) {
      return "Hello! I'm CineBot. Ask me anything about movies, tickets, or offers!";
    } else {
      return "Sorry, I didn't quite catch that. Could you rephrase your question?";
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPicks = allMovies;
    final filteredMovies = searchQuery.isEmpty
        ? topPicks
        : topPicks.where((movie) =>
        movie.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    final Map<String, dynamic>? user = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final moodSuggestions = [
      {'title': 'Action-Packed', 'image': 'assets/moods/action.jpg'},
      {'title': 'Romantic-Feels', 'image': 'assets/moods/romance.jpg'},
      {'title': 'Family-Entertainment', 'image': 'assets/moods/family.jpg'},
      {'title': 'Drama-Mood', 'image': 'assets/moods/drama.jpg'},
      {'title': 'Horror-Thriller', 'image': 'assets/moods/horror.jpg'},
      {'title': 'Sci-Fi', 'image': 'assets/moods/science_fiction.jpg'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CineVision',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hi, how can I help you today?',
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      color: Colors.deepOrange[200],
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Search
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.black),
                        hintText: 'Search ...',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Top Picks or Search Results
                  Text(
                    searchQuery.isEmpty ? 'Top Picks for You' : 'Search Results',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: filteredMovies.isEmpty
                        ? const Center(
                      child: Text(
                        'No movies found.',
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      ),
                    )
                        : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailsScreen(movie: movie),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(movie.posterPath, width: 100, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Mood Suggestions
                  const Text(
                    'Mood Suggestions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: moodSuggestions.length,
                      itemBuilder: (context, index) {
                        final mood = moodSuggestions[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/choose',
                              arguments: mood['title'],
                            );
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(mood['image']!),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  mood['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (user != null)
              Positioned(
                bottom: 20,
                left: 20,
                child: FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(user['image']),
                            radius: 20,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['email'] ?? '',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              GestureDetector(
                                onTap: () {
                                },

                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.deepOrange[200],
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            /// Chat Button / Box
            Positioned(
              bottom: 20,
              right: 20,
              child: _showChatBox
                  ? _buildChatBox()
                  : GestureDetector(
                onTap: () {
                  setState(() {
                    _showChatBox = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.chat_bubble_outline, color: Colors.black),
                      SizedBox(width: 6),
                      Text('Ask CineBot', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
            if (isCineBotExpanded)
              _buildExpandedCineBot(),

            // Positioned 'Ask CineBot' button on top-right
            if (!isCineBotExpanded)
              Positioned(
                top: 20,  // Adjust for top placement
                right: 20,  // Positioned at the top-right
                child: FloatingActionButton.extended(
                  label: const Text("Ask CineBot"),
                  icon: const Icon(Icons.android, color: Colors.deepOrangeAccent,),
                  onPressed: () => setState(() => isCineBotExpanded = true),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildChatBox() {
    return Container(
      width: 320,
      height: 400,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CineBot', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _showChatBox = false;
                  });
                },
              )
            ],
          ),
          const Divider(),

          /// Messages
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('Typing...', style: TextStyle(color: Colors.black87)),
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepOrangeAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    hintText: 'Type your question...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _handleChat(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.deepOrange),
                onPressed: _handleChat,
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _handleChat() {
    final input = _chatController.text.trim();
    if (input.isEmpty) return;
    final AIResponse response = _getAIResponse(_chatController.text.trim());

    _messages.add({'role': 'user', 'text': _chatController.text.trim()});
    _chatController.clear();

    _messages.add({'role': 'ai', 'text': response.text});

// Optional: Showtimes (if available)
    if (response.showtimes != null) {
      for (final time in response.showtimes!) {
        _messages.add({'role': 'ai', 'text': '🕒 $time'});
      }
    }

// Optional: Best Deal (if available)
    if (response.bestDeal != null) {
      _messages.add({'role': 'ai', 'text': '🎟️ Best Deal: ₹${response.bestDeal!.toStringAsFixed(2)}'});
    }

    setState(() {
      _isTyping = true;
      _chatController.clear();
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = false;
      });

      if (response.mood != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushNamed(context, '/choose', arguments: response.mood);
        });
      }
    });
  }

  AIResponse _getAIResponse(String query) {
    final lower = query.toLowerCase();

    // Basic NLP keyword detection
    if (lower.contains('suggest telugu films to watch') || lower.contains('suggest me telugu films')) {
      return AIResponse(
        text: 'Telugu films to watch: Jersey, Hi Nanna, Atharinitiki Daaredhi, Khaleja, Sita Ramam. Would you like me to check available showtimes?',
      );
    }

    if (lower.contains('yes') || lower.contains('show timings')) {
      return AIResponse(
        text: '12:30 PM, 3:45 PM, 6:00 PM',
        showtimes: ['12:30 PM', '3:45 PM', '6:00 PM'],
      );
    }

    if (lower.contains('love') || lower.contains('romantic')) {
      return AIResponse(
        text: 'Aashiqui 2 or 2-States or Sita Ramam could be interesting choices!',
        mood: 'Romantic-Feels',
        showtimes: ['12:30 PM', '3:45 PM', '6:00 PM'],
      );
    }

    if (lower.contains('action') || lower.contains('thrill')) {
      return AIResponse(
        text: 'Fast & Furious or Khaleja could be thrilling choices!',
        mood: 'Action-Packed',
        showtimes: ['12:30 PM', '3:45 PM', '6:00 PM'],
      );
    }

    if (lower.contains('family') || lower.contains('kids')) {
      return AIResponse(
        text: 'You might enjoy "Attarintiki Daredi" or "Hi Nanna" with your family.',
        mood: 'Family-Entertainment',
      );
    }

    if (lower.contains('sci-fi') || lower.contains('space') || lower.contains('technology')) {
      return AIResponse(
        text: 'You should check out "Avatar" or "Doctor Strange"!',
        mood: 'Sci-Fi',
        bestDeal: 129.99,
      );
    }

    if (lower.contains('drama') || lower.contains('emotional')) {
      return AIResponse(
        text: '"Jersey" and "2 States" might tug at your heartstrings.',
        mood: 'Drama-Mood',
      );
    }

    if (lower.contains('hi') || lower.contains('hello')) {
      return AIResponse(
        text: 'hello,how can i help you!',
      );
    }

    if (lower.contains('horror') || lower.contains('scary')) {
      return AIResponse(
        text: 'Looking for chills? Try "The Conjuring" or similar thrillers!',
        mood: 'Horror-Thriller',
      );
    }

    // Default response
    return AIResponse(
      text: 'I’m not sure, but you can browse the top picks or try searching by genre!',
    );
  }

}


class AIResponse {
  final String text;
  final String? mood;
  final List<String>? showtimes;
  final double? bestDeal;
  Map<String, dynamic> _mockSuggestShowtimeAndDeal(String movieName) {
    final movieData = {
      "Fast & Furious": {
        "showtimes": ["1:00 PM", "4:00 PM", "7:30 PM"],
        "price": 180
      },
      "Sita Ramam": {
        "showtimes": ["2:15 PM", "5:00 PM", "9:00 PM"],
        "price": 150
      },
      "Doctor Strange": {
        "showtimes": ["11:00 AM", "3:00 PM", "6:45 PM"],
        "price": 200
      },
      "Hi Nanna": {
        "showtimes": ["12:30 PM", "5:30 PM"],
        "price": 160
      }
    };

    if (!movieData.containsKey(movieName)) {
      return {"movie": movieName, "best_showtime": "N/A", "original_price": 0, "discounted_price": 0};
    }

    final info = movieData[movieName]!;
    final showtimes = info["showtimes"] as List<String>;
    final price = info["price"] as int;
    final bestShowtime = (showtimes..shuffle()).first;
    final discount = price - (10 + (price * 0.1).toInt());
    return {
      "movie": movieName,
      "best_showtime": bestShowtime,
      "original_price": price,
      "discounted_price": discount.clamp(100, price),
    };
  }
  String? _extractMovieNameFromQuery(String query) {
    final movies = ["Fast & Furious", "Sita Ramam", "Doctor Strange", "Hi Nanna"];
    for (var title in movies) {
      if (query.contains(title.toLowerCase())) {
        return title;
      }
    }
    return null;
  }

  AIResponse({
    required this.text,
    this.mood,
    this.showtimes,
    this.bestDeal,
  });
}



