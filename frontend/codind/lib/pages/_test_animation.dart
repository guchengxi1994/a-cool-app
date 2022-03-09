// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection' show IterableMixin;
import 'dart:math';
import 'dart:ui' show Vertices;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class TransformationDemo extends StatefulWidget {
  TransformationDemo({Key? key}) : super(key: key);

  @override
  State<TransformationDemo> createState() => _TransformationDemoState();
}

class _TransformationDemoState extends State<TransformationDemo>
    with TickerProviderStateMixin {
  final GlobalKey _targetKey = GlobalKey();

  final TransformationController _transformationController =
      TransformationController();

  Animation<Matrix4>? _animationReset;
  AnimationController? _controllerReset;
  Matrix4? _homeMatrix;

  void _onAnimateReset() {
    _transformationController.value = _animationReset!.value;
    if (!_controllerReset!.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset!.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset!.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: _homeMatrix,
    ).animate(_controllerReset!);
    _controllerReset!.duration = const Duration(milliseconds: 400);
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset!.forward();
  }

  void _animateResetStop() {
    _controllerReset!.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset!.reset();
  }

  void _onScaleStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset!.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _onTapUp(TapUpDetails details) {
    final renderBox =
        _targetKey.currentContext!.findRenderObject() as RenderBox;
    final offset =
        details.globalPosition - renderBox.localToGlobal(Offset.zero);
    final scenePoint = _transformationController.toScene(offset);
  }

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    if (null != _controllerReset) {
      _controllerReset!.dispose();
    }
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("test"),
      ),
      body: Container(
        color: Colors.grey[300],
        child: LayoutBuilder(builder: (context, constraints) {
          final viewportSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          if (_homeMatrix == null) {
            _homeMatrix = Matrix4.identity()
              ..translate(
                viewportSize.width / 2,
                viewportSize.height / 2,
              );
            _transformationController.value = _homeMatrix!;
          }

          return ClipRect(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: _onTapUp,
              child: InteractiveViewer(
                key: _targetKey,
                scaleEnabled: true,
                transformationController: _transformationController,
                boundaryMargin: EdgeInsets.symmetric(
                  horizontal: viewportSize.width,
                  vertical: viewportSize.height,
                ),
                minScale: 0.01,
                onInteractionStart: _onScaleStart,
                child: SizedBox.expand(
                  child: CustomPaint(
                    painter: _DemoPainter(),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  late Paint _myPaint;
  @override
  void paint(Canvas canvas, Size size) {
    _myPaint = new Paint();
    _myPaint.color = Colors.blue;

    //canvas.drawPaint(_myPaint);
    canvas.drawCircle(Offset(100, 100), 100, _myPaint);
    canvas.drawLine(Offset(300, 300), Offset(400, 400), _myPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
