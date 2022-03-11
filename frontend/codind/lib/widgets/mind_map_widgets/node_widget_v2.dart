import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';

import '_subs.dart';

enum MindMapNodeWidgetStatus { modify, add, read }

// class MindMapNodeWidgetV2 extends StatefulWidget {
//   MindMapNodeWidgetV2(
//       {Key? key,
//       required this.mindMapNodeV2,
//       required this.selectedNode,
//       this.createChild,
//       this.createBro,
//       required this.setSelectedNode})
//       : super(key: key);
//   MindMapNodeV2 mindMapNodeV2;
//   ValueNotifier<String> selectedNode;
//   final Function setSelectedNode;
//   final createChild;
//   final createBro;
//   @override
//   State<MindMapNodeWidgetV2> createState() => _MindMapNodeWidgetV2State();
// }

// class _MindMapNodeWidgetV2State extends State<MindMapNodeWidgetV2> {
//   var isSelected = false;
//   bool isRoot = false;
//   late FocusNode _focusNode = FocusNode();
//   MindMapNodeWidgetStatus status = MindMapNodeWidgetStatus.read;

//   ValueNotifier<String>? selectedNode = null;

//   void handleFocus(uuid) {
//     if (uuid == widget.mindMapNodeV2.id && isSelected == false) {
//       isSelected = true;
//     } else {
//       isSelected = false;
//     }
//     // if (uuid == widget.mindMapNodeV2.id && _focusNode.hasFocus) {
//     //   if (isSelected == false) {
//     //     isSelected = true;
//     //   } else {
//     //     isSelected = false;
//     //   }
//     // }
//   }

//   @override
//   void initState() {
//     super.initState();
//     isRoot = widget.mindMapNodeV2.isRoot!;
//     selectedNode = widget.selectedNode;
//     widget.setSelectedNode(widget.mindMapNodeV2.id);
//     _focusNode.requestFocus();
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).requestFocus(_focusNode);
//         widget.setSelectedNode(widget.mindMapNodeV2.id);
//       },
//       child: ValueListenableBuilder(
//         valueListenable: selectedNode!,
//         builder: (context, value, child) {
//           handleFocus(value);
//           return Row(children: [
//             isRoot
//                 ? StartingNode(isSelected, widget.selectedNode,
//                     widget.setSelectedNode, widget.mindMapNodeV2, _focusNode)
//                 : CommonNode(
//                     isSelected,
//                     widget.selectedNode,
//                     widget.setSelectedNode,
//                     widget.mindMapNodeV2.id,
//                     _focusNode),
//             isSelected
//                 ? isRoot
//                     ? NodeOptions(widget.createChild, widget.createBro, true)
//                     : NodeOptions(widget.createChild, widget.createBro, false)
//                 : Column(),
//           ]);
//         },
//       ),
//     );
//   }

//   Widget buildView() {
//     if (isRoot) {
//       return Container(
//         constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
//         padding:
//             const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
//         child: Text(widget.mindMapNodeV2.label ?? "new node"),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular((20.0)),
//             border: Border.all(color: Colors.blue, width: 0.5)),
//       );
//     } else {
//       return Container(
//         constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
//         padding:
//             const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
//         child: Text(widget.mindMapNodeV2.label ?? "new node"),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular((20.0)),
//             border: Border.all(color: Colors.blue, width: 0.5)),
//       );
//     }
//   }
// }

class Nodulo extends StatefulWidget {
  String? title;
  int? nodeId;
  ValueNotifier<int> selectedNode;
  final Function setSelectedNode;
  final createSon;
  final createBro;
  final controller;

  Nodulo(this.nodeId, this.title, this.selectedNode, this.setSelectedNode,
      this.createSon, this.createBro, this.controller);

  @override
  State<Nodulo> createState() => _NoduloState(nodeId, title, selectedNode,
      setSelectedNode, createSon, createBro, controller);
}

class _NoduloState extends State<Nodulo> {
  var isSelected = false;
  bool isFirst = false;
  late FocusNode myFocusNode = new FocusNode();

  void handleFocus(value) {
    if (value == this.nodeId && isSelected == false) {
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
  final controller;
  _NoduloState(this.nodeId, this.title, this.selectedNode, this.setSelectedNode,
      this.createSon, this.createBro, this.controller);

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
          return Row(children: [
            isFirst
                ? StartingNode(isSelected, selectedNode, setSelectedNode,
                    nodeId, myFocusNode)
                : CommonNode(isSelected, selectedNode, setSelectedNode, nodeId,
                    myFocusNode),
            isSelected
                ? isFirst
                    ? NodeOptions(createSon, createBro, true)
                    : NodeOptions(createSon, createBro, false)
                : Column(),
          ]);
          ;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (this.nodeId == 1) {
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
}
