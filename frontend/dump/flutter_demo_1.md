```dart
// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:collection' show IterableMixin;
import 'dart:math';
import 'dart:ui' show Vertices;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class TransformationsDemo extends StatefulWidget {
  const TransformationsDemo({Key key}) : super(key: key);

  @override
  _TransformationsDemoState createState() => _TransformationsDemoState();
}

class _TransformationsDemoState extends State<TransformationsDemo>
    with TickerProviderStateMixin {
  final GlobalKey _targetKey = GlobalKey();
  // The radius of a hexagon tile in pixels.
  static const _kHexagonRadius = 16.0;
  // The margin between hexagons.
  static const _kHexagonMargin = 1.0;
  // The radius of the entire board in hexagons, not including the center.
  static const _kBoardRadius = 8;

  Board _board = Board(
    boardRadius: _kBoardRadius,
    hexagonRadius: _kHexagonRadius,
    hexagonMargin: _kHexagonMargin,
  );

  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4> _animationReset;
  AnimationController _controllerReset;
  Matrix4 _homeMatrix;

  // Handle reset to home transform animation.
  void _onAnimateReset() {
    _transformationController.value = _animationReset.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  // Initialize the reset to home transform animation.
  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: _homeMatrix,
    ).animate(_controllerReset);
    _controllerReset.duration = const Duration(milliseconds: 400);
    _animationReset.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  // Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onScaleStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _onTapUp(TapUpDetails details) {
    final renderBox = _targetKey.currentContext.findRenderObject() as RenderBox;
    final offset =
        details.globalPosition - renderBox.localToGlobal(Offset.zero);
    final scenePoint = _transformationController.toScene(offset);
    final boardPoint = _board.pointToBoardPoint(scenePoint);
    setState(() {
      _board = _board.copyWithSelected(boardPoint);
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // The scene is drawn by a CustomPaint, but user interaction is handled by
    // the InteractiveViewer parent widget.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text(GalleryLocalizations.of(context).demo2dTransformationsTitle),
      ),
      body: Container(
        color: backgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Draw the scene as big as is available, but allow the user to
            // translate beyond that to a visibleSize that's a bit bigger.
            final viewportSize = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );

            // Start the first render, start the scene centered in the viewport.
            if (_homeMatrix == null) {
              _homeMatrix = Matrix4.identity()
                ..translate(
                  viewportSize.width / 2 - _board.size.width / 2,
                  viewportSize.height / 2 - _board.size.height / 2,
                );
              _transformationController.value = _homeMatrix;
            }

            return ClipRect(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: _onTapUp,
                child: InteractiveViewer(
                  key: _targetKey,
                  scaleEnabled: !kIsWeb,
                  transformationController: _transformationController,
                  boundaryMargin: EdgeInsets.symmetric(
                    horizontal: viewportSize.width,
                    vertical: viewportSize.height,
                  ),
                  minScale: 0.01,
                  onInteractionStart: _onScaleStart,
                  child: SizedBox.expand(
                    child: CustomPaint(
                      size: _board.size,
                      painter: _BoardPainter(
                        board: _board,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      persistentFooterButtons: [resetButton, editButton],
    );
  }

  IconButton get resetButton {
    return IconButton(
      onPressed: () {
        setState(() {
          _animateResetInitialize();
        });
      },
      tooltip: 'Reset',
      color: Theme.of(context).colorScheme.surface,
      icon: const Icon(Icons.replay),
    );
  }

  IconButton get editButton {
    return IconButton(
      onPressed: () {
        if (_board.selected == null) {
          return;
        }
        showModalBottomSheet<Widget>(
            context: context,
            builder: (context) {
              return Container(
                width: double.infinity,
                height: 150,
                padding: const EdgeInsets.all(12),
                child: EditBoardPoint(
                  boardPoint: _board.selected,
                  onColorSelection: (color) {
                    setState(() {
                      _board = _board.copyWithBoardPointColor(
                          _board.selected, color);
                      Navigator.pop(context);
                    });
                  },
                ),
              );
            });
      },
      tooltip: 'Edit',
      color: Theme.of(context).colorScheme.surface,
      icon: const Icon(Icons.edit),
    );
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }
}

// CustomPainter is what is passed to CustomPaint and actually draws the scene
// when its `paint` method is called.
class _BoardPainter extends CustomPainter {
  const _BoardPainter({
    this.board,
  });

  final Board board;

  @override
  void paint(Canvas canvas, Size size) {
    void drawBoardPoint(BoardPoint boardPoint) {
      final color = boardPoint.color.withOpacity(
        board.selected == boardPoint ? 0.7 : 1,
      );
      final vertices = board.getVerticesForBoardPoint(boardPoint, color);
      canvas.drawVertices(vertices, BlendMode.color, Paint());
    }

    board.forEach(drawBoardPoint);
  }

  // We should repaint whenever the board changes, such as board.selected.
  @override
  bool shouldRepaint(_BoardPainter oldDelegate) {
    return oldDelegate.board != board;
  }
}

// The entire state of the hex board and abstraction to get information about
// it. Iterable so that all BoardPoints on the board can be iterated over.
@immutable
class Board extends Object with IterableMixin<BoardPoint> {
  Board({
    @required this.boardRadius,
    @required this.hexagonRadius,
    @required this.hexagonMargin,
    this.selected,
    List<BoardPoint> boardPoints,
  })  : assert(boardRadius > 0),
        assert(hexagonRadius > 0),
        assert(hexagonMargin >= 0) {
    // Set up the positions for the center hexagon where the entire board is
    // centered on the origin.
    // Start point of hexagon (top vertex).
    final hexStart = Point<double>(0, -hexagonRadius);
    final hexagonRadiusPadded = hexagonRadius - hexagonMargin;
    final centerToFlat = sqrt(3) / 2 * hexagonRadiusPadded;
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
      var boardPoint = _getNextBoardPoint(null);
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
  final BoardPoint selected;
  final List<BoardPoint> _boardPoints = <BoardPoint>[];

  @override
  Iterator<BoardPoint> get iterator => _BoardIterator(_boardPoints);

  // For a given q axial coordinate, get the range of possible r values
  // See the definition of BoardPoint for more information about hex grids and
  // axial coordinates.
  _Range _getRRangeForQ(int q) {
    int rStart;
    int rEnd;
    if (q <= 0) {
      rStart = -boardRadius - q;
      rEnd = boardRadius;
    } else {
      rEnd = boardRadius - q;
      rStart = -boardRadius;
    }

    return _Range(rStart, rEnd);
  }

  // Get the BoardPoint that comes after the given BoardPoint. If given null,
  // returns the origin BoardPoint. If given BoardPoint is the last, returns
  // null.
  BoardPoint _getNextBoardPoint(BoardPoint boardPoint) {
    // If before the first element.
    if (boardPoint == null) {
      return BoardPoint(-boardRadius, 0);
    }

    final rRange = _getRRangeForQ(boardPoint.q);

    // If at or after the last element.
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
    const center = BoardPoint(0, 0);
    final distanceFromCenter = getDistance(center, boardPoint);
    return distanceFromCenter <= boardRadius;
  }

  // Get the size in pixels of the entire board.
  Size get size {
    final centerToFlat = sqrt(3) / 2 * hexagonRadius;
    return Size(
      (boardRadius * 2 + 1) * centerToFlat * 2,
      2 * (hexagonRadius + boardRadius * 1.5 * hexagonRadius),
    );
  }

  // Get the distance between two BoardPoints.
  static int getDistance(BoardPoint a, BoardPoint b) {
    final a3 = a.cubeCoordinates;
    final b3 = b.cubeCoordinates;
    return ((a3.x - b3.x).abs() + (a3.y - b3.y).abs() + (a3.z - b3.z).abs()) ~/
        2;
  }

  // Return the q,r BoardPoint for a point in the scene, where the origin is in
  // the center of the board in both coordinate systems. If no BoardPoint at the
  // location, return null.
  BoardPoint pointToBoardPoint(Offset point) {
    final pointCentered = Offset(
      point.dx - size.width / 2,
      point.dy - size.height / 2,
    );
    final boardPoint = BoardPoint(
      ((sqrt(3) / 3 * pointCentered.dx - 1 / 3 * pointCentered.dy) /
              hexagonRadius)
          .round(),
      ((2 / 3 * pointCentered.dy) / hexagonRadius).round(),
    );

    if (!_validateBoardPoint(boardPoint)) {
      return null;
    }

    return _boardPoints.firstWhere((boardPointI) {
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
    final centerOfHexZeroCenter = boardPointToPoint(boardPoint);

    final positions = positionsForHexagonAtOrigin.map((offset) {
      return offset.translate(centerOfHexZeroCenter.x, centerOfHexZeroCenter.y);
    }).toList();

    return Vertices(
      VertexMode.triangleFan,
      positions,
      colors: List<Color>.filled(positions.length, color),
    );
  }

  // Return a new board with the given BoardPoint selected.
  Board copyWithSelected(BoardPoint boardPoint) {
    if (selected == boardPoint) {
      return this;
    }
    final nextBoard = Board(
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
    final nextBoardPoint = boardPoint.copyWithColor(color);
    final boardPointIndex = _boardPoints.indexWhere((boardPointI) =>
        boardPointI.q == boardPoint.q && boardPointI.r == boardPoint.r);

    if (elementAt(boardPointIndex) == boardPoint && boardPoint.color == color) {
      return this;
    }

    final nextBoardPoints = List<BoardPoint>.from(_boardPoints);
    nextBoardPoints[boardPointIndex] = nextBoardPoint;
    final selectedBoardPoint =
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

class _BoardIterator extends Iterator<BoardPoint> {
  _BoardIterator(this.boardPoints);

  final List<BoardPoint> boardPoints;
  int currentIndex;

  @override
  BoardPoint current;

  @override
  bool moveNext() {
    if (currentIndex == null) {
      currentIndex = 0;
    } else {
      currentIndex++;
    }

    if (currentIndex >= boardPoints.length) {
      current = null;
      return false;
    }

    current = boardPoints[currentIndex];
    return true;
  }
}

// A range of q/r board coordinate values.
@immutable
class _Range {
  const _Range(this.min, this.max)
      : assert(min != null),
        assert(max != null),
        assert(min <= max);

  final int min;
  final int max;
}

// A location on the board in axial coordinates.
// Axial coordinates use two integers, q and r, to locate a hexagon on a grid.
// https://www.redblobgames.com/grids/hexagons/#coordinates-axial
@immutable
class BoardPoint {
  const BoardPoint(
    this.q,
    this.r, {
    this.color = const Color(0xFFCDCDCD),
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
  int get hashCode => hashValues(q, r);

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
```