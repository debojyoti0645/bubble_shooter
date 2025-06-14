import 'dart:ui'; // Add this import at the top

import 'package:flutter/material.dart';

import '../models/tube.dart';
import 'ball_widget.dart';

class TubeWidget extends StatelessWidget {
  final Tube tube;
  final bool isSelected;

  const TubeWidget({super.key, required this.tube, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final tubeHeight = 215.0;
    final tubeWidth = 65.0;
    final ballSize = 45.0;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: tubeWidth,
            height: tubeHeight,
            margin: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
            ),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(1),
                topRight: Radius.circular(1),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(
                color: isSelected
                    ? Colors.deepPurple.shade400.withOpacity(0.8)
                    : Colors.white.withOpacity(0.3),
                width: isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  offset: const Offset(-1, -1),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.2),
                ],
                stops: const [0.1, 0.9],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(tube.capacity, (index) {
                // Visual from top to bottom
                int visualIndex = index;
                int actualIndex = tube.balls.length - 1 - visualIndex;
                if (actualIndex >= 0) {
                  return BallWidget(ball: tube.balls[actualIndex], size: ballSize);
                } else {
                  return SizedBox(height: ballSize, width: ballSize);
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
