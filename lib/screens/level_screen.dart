import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/level_data.dart';
import '../widgets/animated_star.dart';
import 'game_screen.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int unlockedLevel = 1;
  Map<String, int> stars = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final level = await LevelData.getUnlockedLevel();
    final savedStars = await LevelData.getStars();
    setState(() {
      unlockedLevel = level;
      stars = savedStars;
    });
  }

  Widget _buildStarRow(int level) {
    int starCount = stars[level.toString()] ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: AnimatedStar(filled: index < starCount),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levels = List.generate(200, (i) => i + 1);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2A0845),
            const Color(0xFF6441A5),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Select Level',
            style: GoogleFonts.pressStart2p(
              fontSize: 20,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: levels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final level = levels[index];
            final isLocked = level > unlockedLevel;

            return GestureDetector(
              onTap: isLocked
                  ? () => _showLockedDialog(context)
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(level: level),
                        ),
                      ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: isLocked
                      ? LinearGradient(
                          colors: [
                            Colors.grey.shade800,
                            Colors.grey.shade700,
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Color.fromARGB(255, 78, 178, 255),
                            Color.fromARGB(255, 54, 110, 240),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLocked
                          ? Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock_rounded,
                                size: 28,
                                color: Colors.white70,
                              ),
                            )
                          : Text(
                              '$level',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 24,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 8),
                      if (!isLocked) _buildStarRow(level),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A0845),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.lock_rounded, color: Color(0xFFF9D423)),
            SizedBox(width: 8),
            Text(
              'Level Locked',
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          'Complete the previous level to unlock this one!',
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Color(0xFFF9D423)),
            ),
          ),
        ],
      ),
    );
  }
}
