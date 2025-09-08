import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeBonusNotification extends StatefulWidget {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const WelcomeBonusNotification(),
    );
  }

  const WelcomeBonusNotification({super.key});

  @override
  State<WelcomeBonusNotification> createState() => _WelcomeBonusNotificationState();
}

class _WelcomeBonusNotificationState extends State<WelcomeBonusNotification> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.purple.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.celebration,
              color: Colors.amber,
              size: 50,
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome!',
              style: GoogleFonts.pressStart2p(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You received 10 bubble points as a welcome bonus!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.pressStart2p(
                color: Colors.amber,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}