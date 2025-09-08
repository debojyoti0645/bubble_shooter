import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/points_service.dart';

class BubblePointsDisplay extends StatefulWidget {
  final bool showBackground;
  
  const BubblePointsDisplay({
    super.key, 
    this.showBackground = true,
  });

  @override
  State<BubblePointsDisplay> createState() => _BubblePointsDisplayState();
}

class _BubblePointsDisplayState extends State<BubblePointsDisplay> {
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final points = await PointsService.getPoints();
    if (mounted) {
      setState(() {
        _points = points;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: widget.showBackground ? BoxDecoration(
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
          const Icon(
            Icons.bubble_chart,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 4),
          Text(
            '$_points',
            style: GoogleFonts.pressStart2p(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}