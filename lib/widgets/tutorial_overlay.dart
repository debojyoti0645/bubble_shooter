import 'package:flutter/material.dart';

class TutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;
  final Size screenSize;
  final Map<String, Offset> buttonPositions;

  const TutorialOverlay({
    Key? key,
    required this.onComplete,
    required this.screenSize,
    required this.buttonPositions,
  }) : super(key: key);

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int currentStep = 0;
  late List<TutorialStep> steps;

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  void _initializeSteps() {
    steps = [
      TutorialStep(
        position: widget.buttonPositions['undo']!,
        text: "UNDO\nReverse your last move\n(5 per level)",
        icon: Icons.undo_rounded,
        arrowDirection: ArrowDirection.down,
      ),
      TutorialStep(
        position: widget.buttonPositions['hint']!,
        text: "HINT\nGet help with your next move\n(1 per level)",
        icon: Icons.lightbulb_outline,
        arrowDirection: ArrowDirection.down,
      ),
      TutorialStep(
        position: widget.buttonPositions['restart']!,
        text: "RESTART\nStart the level over",
        icon: Icons.refresh_rounded,
        arrowDirection: ArrowDirection.down,
      ),
      TutorialStep(
        position: Offset(
          widget.screenSize.width * 0.5,
          widget.screenSize.height * 0.5,
        ),
        text: "Tap tubes to move balls\nMatch all colors to win!",
        icon: Icons.touch_app_rounded,
        arrowDirection: ArrowDirection.up,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep >= steps.length) return const SizedBox.shrink();

    final step = steps[currentStep];
    
    return Stack(
      children: [
        // Semi-transparent background
        GestureDetector(
          onTap: _nextStep,
          child: Container(
            color: Colors.black54,
          ),
        ),
        
        // Tooltip with arrow
        Positioned(
          left: step.position.dx - 100,
          top: step.arrowDirection == ArrowDirection.down 
              ? step.position.dy + 50
              : step.position.dy - 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (step.arrowDirection == ArrowDirection.up)
                _buildArrow(ArrowDirection.up),
              Container(
                padding: const EdgeInsets.all(16),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(step.icon, size: 32, color: Colors.deepPurple),
                    const SizedBox(height: 8),
                    Text(
                      step.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              if (step.arrowDirection == ArrowDirection.down)
                _buildArrow(ArrowDirection.down),
            ],
          ),
        ),
        
        // Step counter
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Step ${currentStep + 1}/${steps.length} - Tap to continue',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrow(ArrowDirection direction) {
    return CustomPaint(
      size: const Size(20, 10),
      painter: ArrowPainter(direction),
    );
  }

  void _nextStep() {
    setState(() {
      if (currentStep < steps.length - 1) {
        currentStep++;
      } else {
        widget.onComplete();
      }
    });
  }
}

enum ArrowDirection { up, down }

class ArrowPainter extends CustomPainter {
  final ArrowDirection direction;

  ArrowPainter(this.direction);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    if (direction == ArrowDirection.down) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    } else {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TutorialStep {
  final Offset position;
  final String text;
  final IconData icon;
  final ArrowDirection arrowDirection;

  TutorialStep({
    required this.position,
    required this.text,
    required this.icon,
    required this.arrowDirection,
  });
}