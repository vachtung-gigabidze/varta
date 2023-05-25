import 'dart:ui' show Vertices;

import 'package:flutter/material.dart';
import 'package:varta/playground/pages/board/board.dart';
import 'package:varta/playground/pages/board/board_point.dart';

class BoardPainter extends CustomPainter {
  const BoardPainter({required this.board});

  final Board board;

  @override
  void paint(Canvas canvas, Size size) {
    void drawBoardPoint(BoardPoint? boardPoint) {
      final Color color = boardPoint!.color.withOpacity(
        board.selected == boardPoint ? 0.7 : 1,
      );
      final Vertices vertices =
          board.getVerticesForBoardPoint(boardPoint, color);
      canvas.drawVertices(vertices, BlendMode.color, Paint());
    }

    void drawBoardField(BoardPoint? boardPoint) {
      if (boardPoint == null) {
        return;
      }
      //const Color color = Colors.transparent;
      final Vertices vertices =
          board.getVerticesForBoardField(boardPoint, boardPoint.color);
      canvas.drawVertices(vertices, BlendMode.color, Paint());
    }

    //Draw background field
    drawBoardField(const BoardPoint(-1, -1, color: Colors.red));

    board.forEach(drawBoardPoint);
  }

  // We should repaint whenever the board changes, such as board.selected.
  @override
  bool shouldRepaint(BoardPainter oldDelegate) {
    return oldDelegate.board != board;
  }
}
