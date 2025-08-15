import 'package:flutter/material.dart';

// Import screen classes
import 'screens/choose_movie_screen.dart';
import 'screens/movie_details_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'screens/mobile_ticket_screen.dart';
import 'screens/home_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';  // Import your login screen

import 'models/movie.dart';

void main() {
  runApp(CineVisionApp());
}

class CineVisionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineVision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF1B103B),
      ),
      initialRoute: '/landing',
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => LoginScreen(),
      },
      // Initial screen is the landing page
      onGenerateRoute: (settings) {

        switch (settings.name) {
          case '/':
          case '/landing':
            return MaterialPageRoute(builder: (_) => const LandingScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen()); // Added login screen route
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/choose':
            final mood = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ChooseMovieScreen(mood: mood),
            );
          case '/details':
            final movie = settings.arguments as Movie;
            return MaterialPageRoute(
              builder: (_) => MovieDetailsScreen(movie: movie),
            );
          case '/seats':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => SeatSelectionScreen(
                movie: args['movie'],
                date: args['date'],
                time: args['time'],
                theatre: args['theatre'],
              ),
            );
        case '/ticket':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => MobileTicketScreen(
                movie: args['movie'],
                date: args['date'],
                time: args['time'],
                theatre: args['theatre'],
                selectedSeats: args['selectedSeats'],
              ),
            );
          case '/payment':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => PaymentScreen(
                movie: args['movie'],
                date: args['date'],
                time: args['time'],
                theatre: args['theatre'],
                selectedSeats: args['selectedSeats'],
                totalAmount: args['totalAmount'],
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Unknown route')),
              ),
            );
        }
      },
    );
  }
}
