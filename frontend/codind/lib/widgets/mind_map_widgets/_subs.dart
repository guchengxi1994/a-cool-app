import 'package:flutter/material.dart';

class StartingNode extends StatelessWidget {
  bool isSelected;
  ValueNotifier<String?> selectedNode;
  Function setSelectedNode;
  final changeNode;
  String? nodeId;
  var myFocusNode;
  String? title;

  StartingNode(this.isSelected, this.selectedNode, this.setSelectedNode,
      this.nodeId, this.myFocusNode, this.changeNode, this.title,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var result = "";

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(50),
          width: 350,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(width: 3, color: Colors.amber)
                  : Border.all(width: 2, color: Colors.red.shade900),
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
                child: Column(
                  children: [
                    TextFormField(
                        onChanged: (value) {
                          // changeNode(value);
                          result = value;
                        },
                        focusNode: myFocusNode,
                        onTap: () {
                          setSelectedNode(nodeId);
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                          focusColor: Colors.amber,
                          contentPadding: EdgeInsets.all(0),
                          hintText: title,
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  changeNode(result);
                },
                icon: const Icon(
                  Icons.check,
                  size: 35,
                  color: Colors.green,
                )),
            const SizedBox(
              width: 30,
            ),
            IconButton(
                onPressed: () {
                  myFocusNode.unfocus();
                },
                icon: const Icon(
                  Icons.close,
                  size: 35,
                  color: Colors.red,
                ))
          ],
        )
      ],
    );
  }
}

class CommonNode extends StatelessWidget {
  bool isSelected;
  ValueNotifier<String?> selectedNode;
  Function setSelectedNode;
  String? nodeId;
  var myFocusNode;
  String? title;

  CommonNode(this.isSelected, this.selectedNode, this.setSelectedNode,
      this.nodeId, this.myFocusNode, this.title);

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
                  hintText: title! + "(${nodeId!.substring(0, 3)})",
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class NodeOptions extends StatelessWidget {
  var createSon;
  var createBro;
  var deleteSelf;
  bool isFirst;

  NodeOptions(this.createSon, this.createBro, this.isFirst, this.deleteSelf);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 80,
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
                  IconButton(
                      onPressed: deleteSelf, icon: const Icon(Icons.delete)),
                  IconButton(
                      onPressed: createSon, icon: const Icon(Icons.plus_one)),
                  IconButton(
                      onPressed: createBro,
                      icon: const Icon(Icons.subdirectory_arrow_right))
                ],
              ));
  }
}
