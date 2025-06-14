import 'ball.dart';

class Tube {
  final int capacity;
  final List<Ball> balls;

  Tube({required this.capacity, List<Ball>? balls})
      : balls = balls ?? [];

  // Check if tube is full
  bool get isFull => balls.length >= capacity;

  // Check if tube is empty
  bool get isEmpty => balls.isEmpty;

  // Check if all balls in tube are same color and tube is full
  bool isComplete() {
    if (balls.length != capacity) return false;
    final firstColor = balls.first.color;
    return balls.every((ball) => ball.color == firstColor);
  }

  // Add ball if not full and ball matches last ball or tube is empty
  bool canAddBall(Ball ball) {
    if (isFull) return false;
    if (isEmpty) return true;
    return balls.last.color == ball.color;
  }

  // Remove and return top ball
  Ball? removeTopBall() {
    if (isEmpty) return null;
    return balls.removeLast();
  }

  // Add ball on top
  void addBall(Ball ball) {
    if (!isFull) balls.add(ball);
  }
}
