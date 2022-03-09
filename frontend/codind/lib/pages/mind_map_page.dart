import 'package:codind/bloc/my_blocs.dart';
import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late MindMapBloc _mindMapBloc;

  @override
  void initState() {
    super.initState();
    _mindMapBloc = context.read<MindMapBloc>();
  }

  @override
  baseBuild(BuildContext context) {
    return BlocBuilder<MindMapBloc, MindMapState>(builder: ((context, state) {
      debugPrint("[debug Matrix] : ${super.transformationController.value}");
      return CustomPaint(
        foregroundPainter:
            MindMapPainter(mindMapNodes: _mindMapBloc.state.mindMapNodes),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: _mindMapBloc.state.mindMapNodes.map((e) {
              return MindMapNodeWidget(
                mindMapNode: e,
              );
            }).toList(),
          ),
        ),
      );
    }));
  }
}

class MindMapPainter extends CustomPainter {
  List<MindMapNode> mindMapNodes;
  MindMapPainter({required this.mindMapNodes});
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
  bool shouldRepaint(covariant MindMapPainter oldDelegate) {
    return oldDelegate.mindMapNodes == mindMapNodes;
  }
}

class MindMapNodeWidget extends StatefulWidget {
  MindMapNodeWidget({Key? key, required this.mindMapNode}) : super(key: key);
  MindMapNode? mindMapNode;

  @override
  State<MindMapNodeWidget> createState() => _MindMapNodeWidgetState();
}

class _MindMapNodeWidgetState extends State<MindMapNodeWidget> {
  late double dx;
  late double dy;

  @override
  void initState() {
    super.initState();
    if (widget.mindMapNode != null) {
      dx = widget.mindMapNode!.left;
      dy = widget.mindMapNode!.top;
    }
  }

  moveTO(Offset offset_) {
    setState(() {
      // offset = offset_;
      dx = offset_.dx;
      dy = offset_.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx,
      top: dy,
      child: Draggable(
        onDraggableCanceled: (velocity, offset) {
          moveTO(offset);
        },
        feedback: Container(
            // height: iconSize,
            // width: iconSize,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.blueAccent, width: 0.5))),
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () async {
            debugPrint("aaaaaaaa");
          },
          child: Container(
            color: Colors.transparent,
            // height: iconSize,
            // width: iconSize,
            child: Container(
              child: Text(widget.mindMapNode!.name!),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((20.0)),
                  border: Border.all(color: Colors.blue, width: 0.5)),
            ),
          ),
        ),
      ),
    );
  }
}
