import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';

import '_subs.dart';

enum MindMapNodeWidgetStatus { modify, add, read }

class MindMapNodeWidgetV2 extends StatefulWidget {
  String? title;
  int? nodeId;
  ValueNotifier<int> selectedNode;
  final Function setSelectedNode;
  final createSon;
  final createBro;
  final controller;
  final deleteNode;
  final changeNode;

  MindMapNodeWidgetV2(
      this.nodeId,
      this.title,
      this.selectedNode,
      this.setSelectedNode,
      this.createSon,
      this.createBro,
      this.controller,
      this.deleteNode,
      this.changeNode);

  @override
  State<MindMapNodeWidgetV2> createState() => _MindMapNodeWidgetV2State(
      nodeId,
      title,
      selectedNode,
      setSelectedNode,
      createSon,
      createBro,
      controller,
      deleteNode,
      changeNode);
}

class _MindMapNodeWidgetV2State extends State<MindMapNodeWidgetV2> {
  var isSelected = false;
  bool isFirst = false;
  late FocusNode myFocusNode = FocusNode();

  void handleFocus(value) {
    if (value == nodeId && isSelected == false) {
      isSelected = true;
    } else {
      isSelected = false;
    }
  }

  int? nodeId;
  String? title;
  ValueNotifier<int> selectedNode;
  final Function setSelectedNode;
  final createSon;
  final createBro;
  final deleteNode;
  final controller;
  final changeNode;
  _MindMapNodeWidgetV2State(
      this.nodeId,
      this.title,
      this.selectedNode,
      this.setSelectedNode,
      this.createSon,
      this.createBro,
      this.controller,
      this.deleteNode,
      this.changeNode);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setSelectedNode(nodeId);
      },
      onLongPress: () {
        setSelectedNode(nodeId);
      },
      child: ValueListenableBuilder(
        valueListenable: selectedNode,
        builder: (context, value, child) {
          handleFocus(value);
          // return Row(children: [
          //   isFirst
          //       ? StartingNode(isSelected, selectedNode, setSelectedNode,
          //           nodeId, myFocusNode)
          //       : CommonNode(isSelected, selectedNode, setSelectedNode, nodeId,
          //           myFocusNode),
          //   isSelected
          //       ? isFirst
          //           ? NodeOptions(createSon, createBro, true)
          //           : NodeOptions(createSon, createBro, false)
          //       : Column(),
          // ]);
          return buildView();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (nodeId == 1) {
      isFirst = true;
    }
    setSelectedNode(nodeId);
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
          child: Text(title ?? "new node"),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)),
              border: Border.all(color: Colors.blue, width: 0.5)),
        );
      } else {
        return Row(
          children: [
            StartingNode(isSelected, selectedNode, setSelectedNode, nodeId,
                myFocusNode, changeNode),
            NodeOptions(createSon, createBro, true, deleteNode)
          ],
        );
      }
    } else {
      if (!isSelected) {
        return Container(
          constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Text(title ?? "new node"),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)),
              border: Border.all(color: Colors.blue, width: 0.5)),
        );
      } else {
        return Row(
          children: [
            CommonNode(
                isSelected, selectedNode, setSelectedNode, nodeId, myFocusNode),
            NodeOptions(createSon, createBro, false, deleteNode)
          ],
        );
      }
    }
  }
}
