import 'package:flutter/material.dart';

class AnimatedStar extends StatefulWidget {
  final bool filled;
  
  const AnimatedStar({super.key, required this.filled});

  @override
  State<AnimatedStar> createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<AnimatedStar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.filled) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Stack(
        children: [
          // Shadow/Border layer
          Icon(
            widget.filled ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 24,
            color: Colors.black54,
          ),
          // Main star layer, slightly smaller
          Icon(
            widget.filled ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 22,
            color: widget.filled 
                ? const Color(0xFFFFD700) // Gold color
                : Colors.grey.shade400,
          ),
          if (widget.filled)
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}