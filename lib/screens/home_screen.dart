import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'level_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BouncingBallsBackground(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2A0845).withOpacity(0.9),
                  const Color(0xFF6441A5).withOpacity(0.9),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Bubble\nSort',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 48,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                    // Play Button
                    _buildButton(
                      context,
                      'Play',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LevelScreen()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Settings Button
                    _buildButton(
                      context,
                      'Settings',
                      (){},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF4E50),
            Color(0xFFF9D423),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BouncingBallsBackground extends StatefulWidget {
  const BouncingBallsBackground({super.key});

  @override
  State<BouncingBallsBackground> createState() => _BouncingBallsBackgroundState();
}

class _BouncingBallsBackgroundState extends State<BouncingBallsBackground>
    with TickerProviderStateMixin {
  final List<Ball> balls = [];
  final int numberOfBalls = 15;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberOfBalls; i++) {
      balls.add(Ball(this));
    }
  }

  @override
  void dispose() {
    for (var ball in balls) {
      ball.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: balls.map((ball) {
        return AnimatedBuilder(
          animation: ball.controller,
          builder: (context, child) {
            return Positioned(
              left: ball.x,
              top: ball.y,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: ball.size,
                  height: ball.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        ball.color.withOpacity(0.8),
                        ball.color.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class Ball {
  late double x;
  late double y;
  late double dx;
  late double dy;
  late double size;
  late Color color;
  late AnimationController controller;

  Ball(TickerProvider vsync) {
    final random = math.Random();
    size = random.nextDouble() * 30 + 20; // Random size between 20 and 50
    x = random.nextDouble() * 300;
    y = random.nextDouble() * 500;
    dx = (random.nextDouble() - 0.5) * 5;
    dy = (random.nextDouble() - 0.5) * 5;
    color = Colors.primaries[random.nextInt(Colors.primaries.length)];

    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 1000),
    )..addListener(() {
        x += dx;
        y += dy;

        if (x < 0 || x > 300) dx *= -1;
        if (y < 0 || y > 500) dy *= -1;
      });

    controller.repeat();
  }
}
