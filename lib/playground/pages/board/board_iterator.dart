import 'package:flutter/material.dart';
import 'package:varta/playground/pages/board/board_point.dart';

class BoardIterator extends Iterator<BoardPoint?> {
  BoardIterator(this.boardPoints);

  final List<BoardPoint> boardPoints;
  int? currentIndex;

  @override
  BoardPoint? current;

  @override
  bool moveNext() {
    if (currentIndex == null) {
      currentIndex = 0;
    } else {
      currentIndex = currentIndex! + 1;
    }

    if (currentIndex! >= boardPoints.length) {
      current = null;
      return false;
    }

    current = boardPoints[currentIndex!];
    return true;
  }
}

@immutable
class Range {
  const Range(this.min, this.max) : assert(min <= max);

  final int min;
  final int max;
}
