import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

@immutable
class BoardPoint {
  /// Конструктор
  const BoardPoint(
    this.q,
    this.r, {
    this.color = const Color.fromARGB(255, 14, 153, 37),
  });

  final int q;
  final int r;
  final Color color;

  @override
  String toString() {
    return 'BoardPoint($q, $r, $color)';
  }

  // Only compares by location.
  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is BoardPoint && other.q == q && other.r == r;
  }

  @override
  int get hashCode => Object.hash(q, r);

  BoardPoint copyWithColor(Color nextColor) =>
      BoardPoint(q, r, color: nextColor);

  // Convert from q,r axial coords to x,y,z cube coords.
  Vector3 get cubeCoordinates {
    return Vector3(
      q.toDouble(),
      r.toDouble(),
      (-q - r).toDouble(),
    );
  }
}
