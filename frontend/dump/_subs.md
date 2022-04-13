```dart

import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';

class StartingNode extends StatelessWidget {
  bool isSelected;
  ValueNotifier<String?> selectedNode;
  Function setSelectedNode;
  // String? nodeId;
  MindMapNodeV2 mapNodeV2;
  var myFocusNode;

  StartingNode(this.isSelected, this.selectedNode, this.setSelectedNode,
      this.mapNodeV2, this.myFocusNode);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(50),
      constraints: const BoxConstraints(minHeight: 20, minWidth: 40),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      // width: 350,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(width: 3, color: Colors.amber)
            : Border.all(width: 2, color: Colors.red.shade900),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withAlpha(60),
        //     blurRadius: 10,
        //     spreadRadius: 5,
        //   )
        // ]
      ),
      child: myFocusNode.hasFocus
          ? SizedBox(
              width: 100,
              child: TextFormField(
                onChanged: null,
                focusNode: myFocusNode,
                onTap: () {
                  setSelectedNode(mapNodeV2.id);
                },
                maxLines: null,
                decoration: InputDecoration(
                  focusColor: Colors.amber,
                  contentPadding: EdgeInsets.all(0),
                  hintText: 'Mensagem de boas-vindas',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
          : Container(
              child: Text(mapNodeV2.label!),
            ),
    );
  }
}

class NodeOptions extends StatelessWidget {
  var createSon;
  var createBro;
  bool isFirst;

  NodeOptions(this.createSon, this.createBro, this.isFirst);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: isFirst
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: createSon, icon: Icon(Icons.plus_one))
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: createSon, icon: Icon(Icons.plus_one)),
                  IconButton(onPressed: createSon, icon: Icon(Icons.add)),
                ],
              ));
  }
}

class CommonNode extends StatelessWidget {
  bool isSelected;
  ValueNotifier<String?> selectedNode;
  Function setSelectedNode;
  String? nodeId;
  var myFocusNode;

  CommonNode(this.isSelected, this.selectedNode, this.setSelectedNode,
      this.nodeId, this.myFocusNode);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 250,
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(width: 3, color: Colors.amber)
              : Border.all(width: 2, color: Colors.lightBlue.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(60),
              blurRadius: 10,
              spreadRadius: 5,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 20,
              height: 20,
              margin: EdgeInsets.only(right: 10),
              child: Center(
                child: Text('${this.nodeId}'),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: TextFormField(
                onChanged: null,
                focusNode: myFocusNode,
                onTap: () {
                  setSelectedNode(nodeId);
                },
                maxLines: null,
                decoration: InputDecoration(
                  focusColor: Colors.amber,
                  contentPadding: EdgeInsets.all(0),
                  hintText: 'Escreva algo!',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
```