import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _playStartupSound();

    // Navigate to login screen after animation
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Future<void> _playStartupSound() async {
    await _audioPlayer.play(AssetSource('audio/startup.wav'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[900],
      body: Stack(
        children: [
          // 1. Matrix style lines
          Positioned.fill(
            child: CustomPaint(
              painter: MatrixLinesPainter(),
            ),
          ),

          // 2. Lottie background animation (e.g., circuit or lightwave)
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/a2.json',
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),

          // 3. Radial glow overlay
          AnimatedContainer(
            duration: const Duration(seconds: 3),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.deepOrangeAccent.withOpacity(0.2),
                  Colors.black.withOpacity(0.7),
                ],
                radius: 1.0,
                center: Alignment.center,
              ),
            ),
          ),

          // 4. Center Text with glowing animation
          Center(
            child: ScaleTransition(
              scale: _glowAnimation,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  'CineVision',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        blurRadius: 30,
                        color: Colors.deepOrangeAccent.withOpacity(0.6),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MatrixLinesPainter extends CustomPainter {
  final Random _random = Random();
  static const int _numLines = 30;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepOrangeAccent.withOpacity(0.1)
      ..strokeWidth = 1;

    for (int i = 0; i < _numLines; i++) {
      final startX = _random.nextDouble() * size.width;
      final startY = _random.nextDouble() * size.height;
      final endY = startY + _random.nextDouble() * 60 + 20;
      canvas.drawLine(Offset(startX, startY), Offset(startX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
