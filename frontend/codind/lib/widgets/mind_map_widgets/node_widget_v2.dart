import 'package:flutter/material.dart';

import '_subs.dart';

enum MindMapNodeWidgetStatus { modify, add, read }

// ignore: must_be_immutable
class MindMapNodeWidgetV2 extends StatefulWidget {
  String? title;
  String? nodeId;
  ValueNotifier<String> selectedNode;
  final Function setSelectedNode;
  final createSon;
  final createBro;
  final controller;
  final deleteNode;
  final changeNode;
  final isFirst;

  MindMapNodeWidgetV2(
      this.nodeId,
      this.title,
      this.selectedNode,
      this.setSelectedNode,
      this.createSon,
      this.createBro,
      this.controller,
      this.deleteNode,
      this.changeNode,
      this.isFirst,
      {Key? key})
      : super(key: key);

  @override
  State<MindMapNodeWidgetV2> createState() => _MindMapNodeWidgetV2State();
}

class _MindMapNodeWidgetV2State extends State<MindMapNodeWidgetV2> {
  var isSelected = false;
  bool isFirst = false;
  late FocusNode myFocusNode = FocusNode();

  void handleFocus(value) {
    if (value == widget.nodeId && isSelected == false) {
      isSelected = true;
    } else {
      isSelected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.setSelectedNode(widget.nodeId);
      },
      onLongPress: () {
        widget.setSelectedNode(widget.nodeId);
      },
      child: ValueListenableBuilder(
        valueListenable: widget.selectedNode,
        builder: (context, value, child) {
          handleFocus(value);
          return buildView();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // if (nodeId == 1) {
    //   isFirst = true;
    // }
    isFirst = widget.isFirst;
    widget.setSelectedNode(widget.nodeId);
    myFocusNode.requestFocus();
    //controller.value = Matrix4.identity();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  Widget buildView() {
    if (isFirst) {
      if (!isSelected) {
        return Container(
          constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Text(widget.title ?? "new node"),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)),
              border: Border.all(color: Colors.blue, width: 0.5)),
        );
      } else {
        return Row(
          children: [
            StartingNode(
                isSelected,
                widget.selectedNode,
                widget.setSelectedNode,
                widget.nodeId,
                myFocusNode,
                widget.changeNode,
                widget.title),
            NodeOptions(
                widget.createSon, widget.createBro, true, widget.deleteNode)
          ],
        );
      }
    } else {
      if (!isSelected) {
        return Container(
          constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Text(widget.title ?? "new node"),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)),
              border: Border.all(color: Colors.blue, width: 0.5)),
        );
      } else {
        return Row(
          children: [
            CommonNode(
              isSelected,
              widget.selectedNode,
              widget.setSelectedNode,
              widget.nodeId,
              myFocusNode,
              widget.title,
            ),
            NodeOptions(
                widget.createSon, widget.createBro, false, widget.deleteNode)
          ],
        );
      }
    }
  }
}
