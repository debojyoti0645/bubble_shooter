import 'package:flutter/material.dart';

import '../models/ball.dart';
import '../models/level_data.dart';
import '../models/tube.dart';
import '../widgets/ball_widget.dart';
import '../widgets/tube_widget.dart';

class GameScreen extends StatefulWidget {
  final int level;
  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late List<Tube> tubes;
  Ball? pickedBall;
  int? pickedTubeIndex;

  // Animation controller for floating ball
  late AnimationController _animationController;
  late Animation<double> _floatingAnimation;

  // Store picked ball position
  Offset? _pickedBallPosition;

  // Keep track of tube positions
  final Map<int, GlobalKey> tubeKeys = {};

  @override
  void initState() {
    super.initState();
    _initializeGame();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _floatingAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeGame() {
    const int capacity = 4;  // Keep tube capacity constant
    
    // Determine number of tubes based on level
    int tubeCount;
    if (widget.level == 1) {
      tubeCount = 3;  // First level: 3 tubes
    } else if (widget.level <= 10) {
      tubeCount = 4;  // Levels 2-10: 4 tubes
    } else if (widget.level <= 25) {
      tubeCount = 5;  // Levels 11-25: 5 tubes
    } else {
      tubeCount = 6;  // Levels 26+: 6 tubes
    }

    // Calculate filled tubes (one less than total tubes for empty space)
    int filledTubes = tubeCount - 1;
    
    // Select colors for the level
    List<Color> baseColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ];
    
    // Create balls list
    List<Ball> balls = [];
    for (int i = 0; i < filledTubes; i++) {
      for (int j = 0; j < capacity; j++) {
        balls.add(Ball(baseColors[i]));
      }
    }
    balls.shuffle();

    // Initialize tubes
    tubes = List.generate(tubeCount, (_) => Tube(capacity: capacity));

    // Fill tubes with balls
    int ballIndex = 0;
    for (int i = 0; i < filledTubes; i++) {
      for (int j = 0; j < capacity; j++) {
        tubes[i].addBall(balls[ballIndex++]);
      }
    }

    pickedBall = null;
    pickedTubeIndex = null;
  }

  void _onTubeTap(int index) {
    if (!mounted) return;

    setState(() {
      Tube tappedTube = tubes[index];

      if (pickedBall == null) {
        if (tappedTube.isEmpty) return;
        pickedBall = tappedTube.removeTopBall();
        pickedTubeIndex = index;

        // Store initial position
        final RenderBox? renderBox =
            tubeKeys[index]?.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          _pickedBallPosition = renderBox.localToGlobal(Offset.zero);
        }
      } else {
        if (index == pickedTubeIndex) {
          tappedTube.addBall(pickedBall!);
          pickedBall = null;
          pickedTubeIndex = null;
          _pickedBallPosition = null;
        } else if (tappedTube.canAddBall(pickedBall!)) {
          tappedTube.addBall(pickedBall!);
          pickedBall = null;
          pickedTubeIndex = null;
          _pickedBallPosition = null;
          _checkWin();
        } else {
          tubes[pickedTubeIndex!].addBall(pickedBall!);
          pickedBall = null;
          pickedTubeIndex = null;
          _pickedBallPosition = null;
        }
      }
    });
  }

  void _checkWin() {
    if (tubes.every((tube) => tube.balls.isEmpty || tube.isComplete())) {
      _completeLevel();
    }
  }

  void _completeLevel() async {
    int stars = 3;
    await LevelData.setStars(widget.level, stars);
    await LevelData.unlockNextLevel(widget.level);
    _showWinDialog(stars);
  }

  void _showWinDialog(int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.deepPurple.shade200, width: 4),
            ),
            title: Column(
              children: [
                const Text(
                  '🎉 Level Complete! 🎉',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500 + (i * 200)),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              i < stars
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: Colors.amber,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGameButton(
                  icon: Icons.arrow_back_rounded,
                  label: 'Levels',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                _buildGameButton(
                  icon: Icons.refresh_rounded,
                  label: 'Replay',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _initializeGame();
                    });
                  },
                ),
                _buildGameButton(
                  icon: Icons.arrow_forward_rounded,
                  label: 'Next',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => GameScreen(level: widget.level + 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildGameButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.deepPurple.shade700,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.refresh_rounded,
                color: Colors.deepPurple.shade700,
              ),
            ),
            onPressed: () {
              setState(() {
                _initializeGame();
              });
            },
          ),
          const SizedBox(width: 8),
        ],
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Text(
                'Level ${widget.level}',
                style: TextStyle(
                  color: Colors.deepPurple.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade200,
              Colors.blue.shade300,
              Colors.cyan.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Tubes layout
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 70,
                      children: List.generate(tubes.length, (index) {
                        if (!tubeKeys.containsKey(index)) {
                          tubeKeys[index] = GlobalKey();
                        }
                        return GestureDetector(
                          key: tubeKeys[index],
                          onTap: () => _onTubeTap(index),
                          child: TubeWidget(
                            tube: tubes[index],
                            isSelected: index == pickedTubeIndex,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

              // Floating ball animation
              if (pickedBall != null &&
                  pickedTubeIndex != null &&
                  _pickedBallPosition != null)
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Positioned(
                      left: _pickedBallPosition!.dx + 30,
                      top:
                          _pickedBallPosition!.dy -
                          145 -
                          _floatingAnimation.value,
                      child: BallWidget(ball: pickedBall!, size: 45),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    // Draw random circles
    for (int i = 0; i < 10; i++) {
      double radius = 20 + (i * 2.toDouble());
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
    }

    // Draw diagonal lines
    paint.color = Colors.white.withOpacity(0.05);
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;

    for (double i = 0; i <= size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(0, i), paint);
      canvas.drawLine(Offset(i, size.height), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
