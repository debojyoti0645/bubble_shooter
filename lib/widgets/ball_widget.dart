import 'package:flutter/material.dart';
import '../models/ball.dart';

class BallWidget extends StatelessWidget {
  final Ball ball;
  final double size;

  const BallWidget({super.key, required this.ball, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ball.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black45),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: const Offset(1, 2),
            blurRadius: 3,
          ),
        ],
      ),
    );
  }
}
