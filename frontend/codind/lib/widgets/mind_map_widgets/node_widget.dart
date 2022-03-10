// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';

enum MindMapNodeWidgetStatus { modify, add, read }

// ignore: must_be_immutable
class MindMapNodeWidget extends StatefulWidget {
  MindMapNodeWidget(
      {Key? key,
      required this.mindMapNode,
      this.leftAddButtonClicked,
      this.rightAddButtonClicked,
      required this.fatherWidth})
      : super(key: key);
  MindMapNode? mindMapNode;
  double fatherWidth;
  final leftAddButtonClicked;
  final rightAddButtonClicked;

  @override
  State<MindMapNodeWidget> createState() => MindMapNodeWidgetState();
}

class MindMapNodeWidgetState extends State<MindMapNodeWidget> {
  late double dx;
  late double dy;
  late String nodeName;
  late String nodeUUID;
  MindMapNodeWidgetStatus status = MindMapNodeWidgetStatus.read;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.mindMapNode != null) {
      dx = widget.mindMapNode!.left;
      dy = widget.mindMapNode!.top;
      nodeName = widget.mindMapNode!.name!;
      nodeUUID = widget.mindMapNode!.id!;
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      debugPrint("[debug node_widget]:   ${globalKey.currentContext?.size}");
      var size = globalKey.currentContext!.size;
      if (widget.mindMapNode!.postion == NodePosition.left) {
        if (size!.width > 60) {
          setState(() {
            dx = dx + 100 - 40 - size.width;
            debugPrint("[debug node_widget dx]:   $dx");
          });
        }
      }
    });
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
      key: globalKey,
      left: dx,
      top: dy,
      child: Draggable(
        // onDraggableCanceled: (velocity, offset) {
        // if (!widget.mindMapNode!.isRoot) {
        //   moveTO(offset);
        // }
        // },
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
            setState(() {
              if (status == MindMapNodeWidgetStatus.read) {
                status = MindMapNodeWidgetStatus.add;
              } else if (status == MindMapNodeWidgetStatus.add) {
                status = MindMapNodeWidgetStatus.read;
              }
            });
          },
          onDoubleTap: () {
            setState(() {
              if (status == MindMapNodeWidgetStatus.read) {
                status = MindMapNodeWidgetStatus.modify;
              } else if (status == MindMapNodeWidgetStatus.modify) {
                status = MindMapNodeWidgetStatus.read;
              }
            });
          },
          child: Container(
            color: Colors.transparent,
            child: buildView(),
          ),
        ),
      ),
    );
  }

  Widget buildView() {
    if (status == MindMapNodeWidgetStatus.read) {
      return Container(
        constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Text(nodeName),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((20.0)),
            border: Border.all(color: Colors.blue, width: 0.5)),
      );
    } else if (status == MindMapNodeWidgetStatus.add) {
      return Row(
        children: [
          if (widget.mindMapNode!.postion == NodePosition.left ||
              widget.mindMapNode!.postion == NodePosition.center)
            IconButton(
                onPressed: () {
                  debugPrint("[debug MindMapPage]: left add button clicked");
                  widget.leftAddButtonClicked(nodeUUID);
                  setState(() {
                    status = MindMapNodeWidgetStatus.read;
                  });
                },
                icon: const Icon(Icons.add)),
          const SizedBox(
            width: 10,
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Text(nodeName),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((20.0)),
                border: Border.all(color: Colors.blue, width: 0.5)),
          ),
          const SizedBox(
            width: 10,
          ),
          if (widget.mindMapNode!.postion == NodePosition.right ||
              widget.mindMapNode!.postion == NodePosition.center)
            IconButton(
                onPressed: () {
                  debugPrint("[debug MindMapPage] : right add button clicked");
                  widget.rightAddButtonClicked(nodeUUID);
                  setState(() {
                    status = MindMapNodeWidgetStatus.read;
                  });
                },
                icon: const Icon(Icons.add)),
        ],
      );
    } else {
      String _nodeName = nodeName;
      return Row(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: SizedBox(
              width: 100,
              child: TextField(
                onChanged: (value) {
                  _nodeName = value;
                },
                maxLines: null,
                maxLength: 100,
                decoration: InputDecoration(hintText: nodeName),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((20.0)),
                border: Border.all(color: Colors.blue, width: 0.5)),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  nodeName = _nodeName;
                  status = MindMapNodeWidgetStatus.read;
                });
              },
              icon: const Icon(
                Icons.check,
                color: Colors.blue,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  status = MindMapNodeWidgetStatus.read;
                });
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.redAccent,
              )),
        ],
      );
    }
  }
}
