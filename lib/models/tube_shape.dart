enum TubeShape {
  standard,
  wide,
  slim,
  zigzag,
  curved;

  static TubeShape getShapeForLevel(int level) {
    if (level <= 10) {
      return TubeShape.standard;
    } else if (level <= 20) {
      return TubeShape.wide;
    } else if (level <= 30) {
      return TubeShape.slim;
    } else if (level <= 40) {
      return TubeShape.zigzag;
    } else {
      return TubeShape.curved;
    }
  }
}