import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/level_data.dart';

class BubblePointsDisplay extends StatelessWidget {
  final bool showBackground;
  
  const BubblePointsDisplay({
    super.key, 
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: LevelData.getBubblePoints(),
      builder: (context, snapshot) {
        final points = snapshot.data ?? 0;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: showBackground ? BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.withOpacity(0.7),
                Colors.blue.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white30),
          ) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bubble_chart,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 4),
              Text(
                '$points',
                style: GoogleFonts.pressStart2p(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}