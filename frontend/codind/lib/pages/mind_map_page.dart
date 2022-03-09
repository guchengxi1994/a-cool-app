import 'package:flutter/material.dart';

import '_base_transformation_page.dart';

/// the idea is inspired by https://dartingowl.com/domind/web/#/

class MindMapPage extends BaseTransformationPage {
  MindMapPage({Key? key}) : super(key: key);

  @override
  BaseTransformationPageState<BaseTransformationPage> getState() {
    return _MindMapPageState();
  }
}

class _MindMapPageState<T> extends BaseTransformationPageState<MindMapPage> {
  @override
  baseBuild(BuildContext context) {
    return CustomPaint(
      painter: _DemoPainter(),
    );
  }
}

class _DemoPainter extends CustomPainter {
  late Paint _myPaint;
  @override
  void paint(Canvas canvas, Size size) {
    _myPaint = Paint();
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
