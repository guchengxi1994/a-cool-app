import 'package:codind/widgets/create_event_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/my_providers.dart' show ExperienceController;

// ignore: must_be_immutable
class ExpandedColumnWidget extends StatefulWidget {
  ExpandedColumnWidget({Key? key, required this.name}) : super(key: key);
  String name;

  @override
  State<ExpandedColumnWidget> createState() => _ExpandedColumnWidgetState();
}

class _ExpandedColumnWidgetState extends State<ExpandedColumnWidget> {
  List<Widget> children = [];
  List memories = [];

  List getMemories() {
    if (children.length > 1) {
      for (int i = 1; i < children.length; i++) {
        if (children[i].runtimeType == DeletableWidget) {}
      }
    }
    return memories;
  }

  void addWidget(Widget? w) {
    int index = children.length;

    if (w != null) {
      children.insert(
          index - 1,
          DeletableWidget(
            child: w,
            index: index - 1,
            removeSelf: (v) => removeWidget(index - 1),
          ));
    } else {
      children.insert(
          index - 1,
          DeletableWidget(
            child: Container(
              height: 150,
              color: const Color.fromARGB(255, 241, 235, 221),
              // margin: const EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
            ),
            index: index - 1,
            removeSelf: (v) => removeWidget(index - 1),
          ));
    }

    setState(() {});

    debugPrint("[expanded_column_widget children.length] : ${children.length}");
  }

  void removeWidget(int index) {
    debugPrint("[expanded_column_widget remove index] : $index");

    // children.removeAt(index);
    Widget w = children.firstWhere((element) {
      if (element.runtimeType == DeletableWidget) {
        return (element as DeletableWidget).index == index;
      } else {
        return false;
      }
    }, orElse: () => Container());

    if (w.runtimeType != Container) {
      var _index = children.indexOf(w);

      context.read<ExperienceController>().removeValue(widget.name, _index);

      setState(() {
        children.remove(w);
      });

      debugPrint(
          "[ExperienceController data] : ${context.read<ExperienceController>().edu}");
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("[ExpandedColumnWidget]: here init state");
    children.add(Container(
      height: 100,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      // width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.white,
        child: IconButton(
          icon: const Icon(
            Icons.add,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () {
            addWidget(TextWidgetV2(
              name: widget.name,
              index: children.length - 1,
            ));
          },
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: children,
      ),
    );
  }
}

// ignore: must_be_immutable
class DeletableWidget extends StatelessWidget {
  DeletableWidget(
      {Key? key,
      required this.child,
      required this.index,
      required this.removeSelf,
      this.textWidgetKey})
      : super(key: key);
  Widget child;
  int index;
  GlobalKey? textWidgetKey;
  // ignore: prefer_typing_uninitialized_variables
  final removeSelf;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Expanded(child: child),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFF0000), width: 0.5),
              color: Colors.white,
              borderRadius: BorderRadius.circular((10.0))),
          child: IconButton(
            iconSize: 24,
            icon: const Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () {
              removeSelf(index);
            },
          ),
        )
      ]),
    );
  }
}

// @Deprecated("dont be used")
// class TextWidget extends StatefulWidget {
//   TextWidget({Key? key, required this.name, required this.index})
//       : super(key: key);
//   String name;
//   int index;

//   @override
//   State<TextWidget> createState() => _TextWidgetState();
// }

// class _TextWidgetState extends State<TextWidget> {
//   String result = "";
//   bool enable = true;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       maxLength: 100,
//       maxLines: 3,
//       enabled: enable,
//       decoration: InputDecoration(
//         disabledBorder: const OutlineInputBorder(
//             borderSide:
//                 BorderSide(color: Color.fromARGB(255, 39, 50, 100), width: 3)),
//         enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.amber, width: 2),
//             borderRadius: BorderRadius.all(Radius.circular(15))),
//         focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.green, width: 3)),
//         suffix: enable
//             ? IconButton(
//                 icon: const Icon(Icons.done),
//                 onPressed: () {
//                   setState(() {
//                     context
//                         .read<ExperienceController>()
//                         .addValue(widget.name, widget.index, result);
//                     enable = false;
//                   });
//                 },
//               )
//             : null,
//       ),
//       onChanged: (v) {
//         result = v;
//       },
//     );
//   }
// }

// ignore: must_be_immutable
class TextWidgetV2 extends StatefulWidget {
  TextWidgetV2({Key? key, required this.name, required this.index})
      : super(key: key);
  String name;
  int index;

  @override
  State<TextWidgetV2> createState() => _TextWidgetV2State();
}

class _TextWidgetV2State extends State<TextWidgetV2> {
  String result = "";
  bool enable = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.grey[100],
      child: CreateEventWidget(
        name: widget.name,
        index: widget.index,
      ),
    );
  }
}
