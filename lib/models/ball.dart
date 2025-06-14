import 'package:flutter/material.dart';

class Ball {
  final Color color;

  Ball(this.color);

  // Equality based on color for matching balls
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ball && runtimeType == other.runtimeType && color == other.color;

  @override
  int get hashCode => color.hashCode;
}
