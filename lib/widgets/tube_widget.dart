import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/tube.dart';
import '../models/tube_shape.dart';
import 'ball_widget.dart';

class TubeWidget extends StatelessWidget {
  final Tube tube;
  final bool isSelected;
  final bool isHintSource;
  final bool isHintTarget;

  const TubeWidget({
    super.key,
    required this.tube,
    this.isSelected = false,
    this.isHintSource = false,
    this.isHintTarget = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size to calculate relative dimensions
    final screenSize = MediaQuery.of(context).size;
    final tubeHeight = screenSize.height * 0.25; // 25% of screen height
    final tubeWidth = _getTubeWidth(tube.shape, screenSize);
    final ballSize = _getBallSize(tube.shape, tubeWidth, tubeHeight);

    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.02), // 2% of screen width
      child: ClipPath(
        clipper: _TubeClipper(tube.shape),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: tubeWidth,
            height: tubeHeight,
            margin: EdgeInsets.only(
              left: screenSize.width * 0.01,
              right: screenSize.width * 0.01,
              bottom: screenSize.width * 0.01,
            ),
            padding: _getTubePadding(tube.shape, tubeWidth),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              border: Border.all(
                color: isHintSource
                    ? Colors.amber.shade400.withOpacity(0.8)
                    : isHintTarget
                        ? Colors.green.shade400.withOpacity(0.8)
                        : isSelected
                            ? Colors.deepPurple.shade400.withOpacity(0.8)
                            : Colors.white.withOpacity(0.3),
                width: isHintSource || isHintTarget || isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  offset: const Offset(-1, -1),
                  blurRadius: 4,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(tube.capacity, (index) {
                int actualIndex = tube.balls.length - 1 - index;
                if (actualIndex >= 0) {
                  return BallWidget(
                    ball: tube.balls[actualIndex],
                    size: ballSize,
                  );
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

  double _getTubeWidth(TubeShape shape, Size screenSize) {
    final baseWidth = screenSize.width * 0.15; // 15% of screen width
    switch (shape) {
      case TubeShape.standard:
        return baseWidth;
      case TubeShape.wide:
        return baseWidth * 1.2;
      case TubeShape.slim:
        return baseWidth * 0.8;
      case TubeShape.zigzag:
        return baseWidth * 1.1;
      case TubeShape.curved:
        return baseWidth * 1.15;
    }
  }

  double _getBallSize(TubeShape shape, double tubeWidth, double tubeHeight) {
    // Calculate ball size based on tube dimensions and capacity
    final maxBallSize = tubeWidth * 0.8; // 80% of tube width
    final maxBallHeight = (tubeHeight / tube.capacity) * 0.8; // Account for spacing
    
    // Use the smaller of width or height to ensure balls fit
    final baseBallSize = maxBallSize < maxBallHeight ? maxBallSize : maxBallHeight;
    
    switch (shape) {
      case TubeShape.standard:
        return baseBallSize;
      case TubeShape.wide:
        return baseBallSize * 0.9;
      case TubeShape.slim:
        return baseBallSize * 0.85;
      case TubeShape.zigzag:
        return baseBallSize * 0.8;
      case TubeShape.curved:
        return baseBallSize * 0.85;
    }
  }

  EdgeInsets _getTubePadding(TubeShape shape, double tubeWidth) {
    final basePadding = tubeWidth * 0.1; // 10% of tube width
    switch (shape) {
      case TubeShape.standard:
        return EdgeInsets.all(basePadding);
      case TubeShape.wide:
        return EdgeInsets.all(basePadding * 1.2);
      case TubeShape.slim:
        return EdgeInsets.all(basePadding * 0.8);
      case TubeShape.zigzag:
        return EdgeInsets.symmetric(
          horizontal: basePadding * 1.2,
          vertical: basePadding,
        );
      case TubeShape.curved:
        return EdgeInsets.all(basePadding * 1.1);
    }
  }
}

class _TubeClipper extends CustomClipper<Path> {
  final TubeShape shape;

  _TubeClipper(this.shape);

  @override
  Path getClip(Size size) {
    switch (shape) {
      case TubeShape.standard:
        return _standardPath(size);
      case TubeShape.wide:
        return _widePath(size);
      case TubeShape.slim:
        return _slimPath(size);
      case TubeShape.zigzag:
        return _zigzagPath(size);
      case TubeShape.curved:
        return _curvedPath(size);
    }
  }

  Path _standardPath(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  Path _widePath(Size size) {
    return Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  Path _slimPath(Size size) {
    return Path()
      ..moveTo(size.width * 0.3, 0)
      ..lineTo(size.width * 0.7, 0)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..close();
  }

  Path _zigzagPath(Size size) {
    final path = Path();
    final segmentHeight = size.height / 8;

    path.moveTo(size.width * 0.3, 0);
    path.lineTo(size.width * 0.7, 0);

    for (var i = 0; i < 8; i++) {
      final isEven = i.isEven;
      path.lineTo(
        isEven ? size.width * 0.8 : size.width * 0.2,
        segmentHeight * (i + 1),
      );
    }

    path.close();
    return path;
  }

  Path _curvedPath(Size size) {
    return Path()
      ..moveTo(size.width * 0.3, 0)
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.2,
        size.width * 0.7, 0,
      )
      ..quadraticBezierTo(
        size.width, size.height * 0.5,
        size.width * 0.8, size.height,
      )
      ..lineTo(size.width * 0.2, size.height)
      ..quadraticBezierTo(
        0, size.height * 0.5,
        size.width * 0.3, 0,
      )
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
