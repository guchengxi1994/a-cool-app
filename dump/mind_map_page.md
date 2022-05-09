```dart

import 'package:codind/bloc/my_blocs.dart';
import 'package:codind/entity/entity.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../lib/pages/_base_transformation_page.dart';

/// the idea is inspired by https://dartingowl.com/domind/web/#/

@Deprecated("should not be used")
class MindMapPage extends BaseTransformationPage {
  MindMapPage({Key? key}) : super(key: key);

  @override
  BaseTransformationPageState<BaseTransformationPage> getState() {
    return _MindMapPageState();
  }
}

class _MindMapPageState<T> extends BaseTransformationPageState<MindMapPage> {
  late MindMapBloc _mindMapBloc;
  List<GlobalKey<MindMapNodeWidgetState>> keys = [];
  GlobalKey pageKey = GlobalKey();
  var UUID = const Uuid();
  var loadInfoFuture;

  Future<void> loadInfo() async {
    MindMapNode mindMapNode = MindMapNode(
        name: "root",
        id: UUID.v4(),
        properties: null,
        postion: NodePosition.center);
    mindMapNode.isRoot = true;
    GlobalKey<MindMapNodeWidgetState> globalKey = GlobalKey();
    MindMapNodeWidget widget = MindMapNodeWidget(
      fatherWidth: 0,
      mindMapNode: mindMapNode,
      key: globalKey,
      leftAddButtonClicked: (uuid) => addLeftItem(uuid),
      rightAddButtonClicked: (uuid) => addRightItem(uuid),
    );

    _mindMapBloc.add(AddMindMapEventSimple(
        globalKey: globalKey, nodeWidget: widget, mindMapNode: mindMapNode));
  }

  @override
  void initState() {
    super.initState();
    _mindMapBloc = context.read<MindMapBloc>();
    loadInfoFuture = loadInfo();
  }

  @override
  baseBuild(BuildContext context) {
    return BlocBuilder<MindMapBloc, MindMapState>(builder: ((context, state) {
      debugPrint("[debug Matrix] : ${super.transformationController.value}");
      return FutureBuilder(
          future: loadInfoFuture,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomPaint(
                key: pageKey,
                foregroundPainter: MindMapPainter(
                    mindMapNodes: _mindMapBloc.state.mindMapNodes),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: _mindMapBloc.state.widgets,
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }));
    }));
  }

  void reformat() {}

  void addLeftItem(String uuid) {
    keys = _mindMapBloc.state.globalKeys;
    var currentKey = keys.firstWhere((element) {
      return element.currentState!.nodeUUID == uuid;
    });
    var renderObject = currentKey.currentContext?.findRenderObject();
    if (null != renderObject) {
      // print(super.transformationController.value.row0[0]);
      double factor = super.transformationController.value.row0[0];

      var currentWidgetSize = renderObject.paintBounds.size;
      var currentWidgetOffset =
          (renderObject as RenderBox).localToGlobal(Offset.zero);
      var parentOffset =
          (pageKey.currentContext!.findRenderObject() as RenderBox)
              .localToGlobal(Offset.zero);
      debugPrint("[debug mind_map_page]: left add button, $currentWidgetSize");
      debugPrint(
          "[debug mind_map_page]: left add button, $currentWidgetOffset");
      MindMapNode node = MindMapNode(postion: NodePosition.left);
      node.id = UUID.v4();
      node.name = "leftleftleftleftleftleftleftleft";
      node.left = (currentWidgetOffset.dx - parentOffset.dx) / factor - 100;
      node.top = (currentWidgetOffset.dy - parentOffset.dy) / factor;
      GlobalKey<MindMapNodeWidgetState> globalKey = GlobalKey();
      MindMapNodeWidget widget = MindMapNodeWidget(
        fatherWidth: currentWidgetSize.width,
        mindMapNode: node,
        key: globalKey,
        leftAddButtonClicked: (uuid) => addLeftItem(uuid),
        rightAddButtonClicked: (uuid) => addRightItem(uuid),
      );

      debugPrint(
          "[debug mind_map_page]: left item ${globalKey.currentContext?.size}");

      _mindMapBloc.add(AddMindMapEventSimple(
          mindMapNode: node, globalKey: globalKey, nodeWidget: widget));
      debugPrint("[debug mind_map_page]: use bloc to add a widget");
    }
  }

  void addRightItem(String uuid) {
    keys = _mindMapBloc.state.globalKeys;
    var currentKey = keys.firstWhere((element) {
      return element.currentState!.nodeUUID == uuid;
    });
    var renderObject = currentKey.currentContext?.findRenderObject();
    if (null != renderObject) {
      // print(super.transformationController.value.row0[0]);
      double factor = super.transformationController.value.row0[0];

      var currentWidgetSize = renderObject.paintBounds.size;
      var currentWidgetOffset =
          (renderObject as RenderBox).localToGlobal(Offset.zero);
      var parentOffset =
          (pageKey.currentContext!.findRenderObject() as RenderBox)
              .localToGlobal(Offset.zero);
      debugPrint("[debug mind_map_page]: right add button, $currentWidgetSize");
      debugPrint(
          "[debug mind_map_page]: right add button, $currentWidgetOffset");
      MindMapNode node = MindMapNode(postion: NodePosition.right);
      node.id = UUID.v4();
      node.name = "right";
      node.left = (currentWidgetOffset.dx - parentOffset.dx) / factor +
          currentWidgetSize.width +
          40;
      node.top = (currentWidgetOffset.dy - parentOffset.dy) / factor;
      GlobalKey<MindMapNodeWidgetState> globalKey = GlobalKey();
      MindMapNodeWidget widget = MindMapNodeWidget(
        fatherWidth: currentWidgetSize.width,
        mindMapNode: node,
        key: globalKey,
        leftAddButtonClicked: (uuid) => addLeftItem(uuid),
        rightAddButtonClicked: (uuid) => addRightItem(uuid),
      );

      _mindMapBloc.add(AddMindMapEventSimple(
          mindMapNode: node, globalKey: globalKey, nodeWidget: widget));
      debugPrint("[debug mind_map_page]: use bloc to add a widget");
    }
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
    // canvas.drawCircle(Offset(100, 100), 100, _myPaint);
    // canvas.drawLine(Offset(300, 300), Offset(400, 400), _myPaint);
  }

  @override
  bool shouldRepaint(covariant MindMapPainter oldDelegate) {
    return oldDelegate.mindMapNodes == mindMapNodes;
  }
}
```
