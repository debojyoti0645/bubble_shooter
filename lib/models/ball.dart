import 'package:flutter/material.dart';

class Ball {
  final Color color;
  final AnimationController? controller;  // Add this property

  Ball(this.color, {this.controller});  // Update constructor

  // Equality based on color for matching balls
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ball && runtimeType == other.runtimeType && color == other.color;

  @override
  int get hashCode => color.hashCode;
}
