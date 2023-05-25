import 'dart:collection' show IterableMixin;
import 'dart:math' show Point, sqrt, cos, sin, pi;
import 'dart:ui' show Vertices;

import 'package:flutter/material.dart';
import 'package:varta/playground/pages/board/board_iterator.dart';
import 'package:varta/playground/pages/board/board_point.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

@immutable
class Board extends Object with IterableMixin<BoardPoint?> {
  /// Поле
  Board({
    required this.boardRadius,
    required this.hexagonRadius,
    required this.hexagonMargin,
    this.selected,
    List<BoardPoint>? boardPoints,
  })  : assert(boardRadius > 0),
        assert(hexagonRadius > 0),
        assert(hexagonMargin >= 0) {
    // Set up the positions for the center hexagon where the entire board is
    // centered on the origin.
    // Start point of hexagon (top vertex).
    final Point<double> hexStart = Point<double>(0, -hexagonRadius);
    final double hexagonRadiusPadded = hexagonRadius - hexagonMargin;
    final double centerToFlat = sqrt(3) / 2 * hexagonRadiusPadded;
    positionsForHexagonAtOrigin.addAll(<Offset>[
      Offset(hexStart.x, hexStart.y),
      Offset(hexStart.x + centerToFlat, hexStart.y + 0.5 * hexagonRadiusPadded),
      Offset(hexStart.x + centerToFlat, hexStart.y + 1.5 * hexagonRadiusPadded),
      Offset(hexStart.x + centerToFlat, hexStart.y + 1.5 * hexagonRadiusPadded),
      Offset(hexStart.x, hexStart.y + 2 * hexagonRadiusPadded),
      Offset(hexStart.x, hexStart.y + 2 * hexagonRadiusPadded),
      Offset(hexStart.x - centerToFlat, hexStart.y + 1.5 * hexagonRadiusPadded),
      Offset(hexStart.x - centerToFlat, hexStart.y + 1.5 * hexagonRadiusPadded),
      Offset(hexStart.x - centerToFlat, hexStart.y + 0.5 * hexagonRadiusPadded),
    ]);

    if (boardPoints != null) {
      _boardPoints.addAll(boardPoints);
    } else {
      // Generate boardPoints for a fresh board.
      BoardPoint? boardPoint = _getNextBoardPoint(null);
      while (boardPoint != null) {
        _boardPoints.add(boardPoint);
        boardPoint = _getNextBoardPoint(boardPoint);
      }
    }
  }

  final int boardRadius; // Number of hexagons from center to edge.
  final double hexagonRadius; // Pixel radius of a hexagon (center to vertex).
  final double hexagonMargin; // Margin between hexagons.
  final List<Offset> positionsForHexagonAtOrigin = <Offset>[];
  final BoardPoint? selected;
  final List<BoardPoint> _boardPoints = <BoardPoint>[];

  @override
  Iterator<BoardPoint?> get iterator => BoardIterator(_boardPoints);

  // For a given q axial coordinate, get the range of possible r values
  // See the definition of BoardPoint for more information about hex grids and
  // axial coordinates.
  Range _getRRangeForQ(int q) {
    int rStart;
    int rEnd;
    if (q <= 0) {
      rStart = -boardRadius - q;
      rEnd = boardRadius;
    } else {
      rEnd = boardRadius - q;
      rStart = -boardRadius;
    }

    return Range(rStart, rEnd);
  }

  BoardPoint? _getNextBoardPoint(BoardPoint? boardPoint) {
    if (boardPoint == null) {
      return BoardPoint(-boardRadius, 0);
    }

    final Range rRange = _getRRangeForQ(boardPoint.q);

    if (boardPoint.q >= boardRadius && boardPoint.r >= rRange.max) {
      return null;
    }

    // If wrapping from one q to the next.
    if (boardPoint.r >= rRange.max) {
      return BoardPoint(boardPoint.q + 1, _getRRangeForQ(boardPoint.q + 1).min);
    }

    // Otherwise we're just incrementing r.
    return BoardPoint(boardPoint.q, boardPoint.r + 1);
  }

  // Check if the board point is actually on the board.
  bool _validateBoardPoint(BoardPoint boardPoint) {
    const BoardPoint center = BoardPoint(0, 0);
    final int distanceFromCenter = getDistance(center, boardPoint);
    return distanceFromCenter <= boardRadius;
  }

  // Get the size in pixels of the entire board.
  Size get size {
    final double centerToFlat = sqrt(3) / 2 * hexagonRadius;
    return Size(
      (boardRadius * 2 + 1) * centerToFlat * 2,
      2 * (hexagonRadius + boardRadius * 1.5 * hexagonRadius),
    );
  }

  // Get the distance between two BoardPoints.
  static int getDistance(BoardPoint a, BoardPoint b) {
    final Vector3 a3 = a.cubeCoordinates;
    final Vector3 b3 = b.cubeCoordinates;
    return ((a3.x - b3.x).abs() + (a3.y - b3.y).abs() + (a3.z - b3.z).abs()) ~/
        2;
  }

  // Return the q,r BoardPoint for a point in the scene, where the origin is in
  // the center of the board in both coordinate systems. If no BoardPoint at the
  // location, return null.
  BoardPoint? pointToBoardPoint(Offset point) {
    final Offset pointCentered = Offset(
      point.dx - size.width / 2,
      point.dy - size.height / 2,
    );
    final BoardPoint boardPoint = BoardPoint(
      ((sqrt(3) / 3 * pointCentered.dx - 1 / 3 * pointCentered.dy) /
              hexagonRadius)
          .round(),
      ((2 / 3 * pointCentered.dy) / hexagonRadius).round(),
    );

    if (!_validateBoardPoint(boardPoint)) {
      return null;
    }

    return _boardPoints.firstWhere((BoardPoint boardPointI) {
      return boardPointI.q == boardPoint.q && boardPointI.r == boardPoint.r;
    });
  }

  // Return a scene point for the center of a hexagon given its q,r point.
  Point<double> boardPointToPoint(BoardPoint boardPoint) {
    return Point<double>(
      sqrt(3) * hexagonRadius * boardPoint.q +
          sqrt(3) / 2 * hexagonRadius * boardPoint.r +
          size.width / 2,
      1.5 * hexagonRadius * boardPoint.r + size.height / 2,
    );
  }

  // Get Vertices that can be drawn to a Canvas for the given BoardPoint.
  Vertices getVerticesForBoardPoint(BoardPoint boardPoint, Color color) {
    final Point<double> centerOfHexZeroCenter = boardPointToPoint(boardPoint);

    final List<Offset> positions =
        positionsForHexagonAtOrigin.map((Offset offset) {
      return offset.translate(centerOfHexZeroCenter.x, centerOfHexZeroCenter.y);
    }).toList();

    return Vertices(
      VertexMode.triangleFan,
      positions,
      colors: List<Color>.filled(positions.length, color),
    );
  }

  //Координаты доски
  Vertices getVerticesForBoardField(BoardPoint boardPoint, Color color) {
    // const Point<double> centerOfHexZeroCenter =
    // Point<double>(150, 150); //boardPointToPoint(boardPoint);

    const double x = 215.0;
    const double y = 195.0;
    const double hexagonRadiusPadded = 235.0;
    // const double centerToFlat = 200.0;
    final List<Offset> positions = <Offset>[
      for (int a = 0; a < 6; a++)
        Offset(
          x + hexagonRadiusPadded * cos(a * 60 * pi / 180.0),
          y + hexagonRadiusPadded * sin(a * 60 * pi / 180.0),
        )

      // Offset(x, y),
      // Offset(x + centerToFlat, y + 0.5 * hexagonRadiusPadded),
      // Offset(x + centerToFlat, y + 1.5 * hexagonRadiusPadded),
      // Offset(x + centerToFlat, y + 1.5 * hexagonRadiusPadded),
      // Offset(x, y + 2 * hexagonRadiusPadded),
      // Offset(x, y + 2 * hexagonRadiusPadded),
      // Offset(x - centerToFlat, y + 1.5 * hexagonRadiusPadded),
      // Offset(x - centerToFlat, y + 1.5 * hexagonRadiusPadded),
      // Offset(x - centerToFlat, y + 0.5 * hexagonRadiusPadded),
    ];

    //     positionsForHexagonAtOrigin.map((Offset offset) {
    //   return offset.translate(centerOfHexZeroCenter.x, centerOfHexZeroCenter.y);
    // }).toList();

    return Vertices(
      VertexMode.triangleFan,
      positions,
      colors: List<Color>.filled(positions.length, color),
    );
  }

  // Return a new board with the given BoardPoint selected.
  Board copyWithSelected(BoardPoint? boardPoint) {
    if (selected == boardPoint) {
      return this;
    }
    final Board nextBoard = Board(
      boardRadius: boardRadius,
      hexagonRadius: hexagonRadius,
      hexagonMargin: hexagonMargin,
      selected: boardPoint,
      boardPoints: _boardPoints,
    );
    return nextBoard;
  }

  // Return a new board where boardPoint has the given color.
  Board copyWithBoardPointColor(BoardPoint boardPoint, Color color) {
    final BoardPoint nextBoardPoint = boardPoint.copyWithColor(color);
    final int boardPointIndex = _boardPoints.indexWhere(
        (BoardPoint boardPointI) =>
            boardPointI.q == boardPoint.q && boardPointI.r == boardPoint.r);

    if (elementAt(boardPointIndex) == boardPoint && boardPoint.color == color) {
      return this;
    }

    final List<BoardPoint> nextBoardPoints =
        List<BoardPoint>.from(_boardPoints);
    nextBoardPoints[boardPointIndex] = nextBoardPoint;
    final BoardPoint? selectedBoardPoint =
        boardPoint == selected ? nextBoardPoint : selected;
    return Board(
      boardRadius: boardRadius,
      hexagonRadius: hexagonRadius,
      hexagonMargin: hexagonMargin,
      selected: selectedBoardPoint,
      boardPoints: nextBoardPoints,
    );
  }
}
