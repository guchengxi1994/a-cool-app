import 'dart:convert';

import 'package:codind/entity/file_entity.dart';
import 'package:codind/utils/common.dart';
import 'package:flutter/material.dart';

class FileExplorePage extends StatefulWidget {
  FileExplorePage({Key? key}) : super(key: key);

  @override
  State<FileExplorePage> createState() => _FileExplorePageState();
}

class _FileExplorePageState extends State<FileExplorePage> {
  var loadFileFuture;

  @override
  void initState() {
    super.initState();
    loadFileFuture = loadJson();
  }

  Future<String> loadJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString("assets/_json_test.json");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadFileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // print(snapshot.data.toString());
            Map<String, dynamic> data = json.decode(snapshot.data.toString());
            EntityFolder entityFolder = EntityFolder.fromJson(data);
            print(data);
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: renderFiles(entityFolder.children, 0),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  List<Widget> renderFiles(List<Object> list, int depth, {String? fatherPath}) {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].runtimeType == EntityFile) {
        widgets.add(FileWidget(
          index: i,
          appearance: const Icon(Icons.file_present),
          name: (list[i] as EntityFile).name,
        ));
      } else {
        widgets.add(FileWidget(
          index: i,
          appearance: const Icon(Icons.folder),
          name: (list[i] as EntityFolder).name,
        ));
      }
    }
    return widgets;
  }
}

class FileWidget extends StatefulWidget {
  VoidCallback? onDoubleCilck;
  Icon appearance;
  String name;
  String? tooltip;
  int index;

  FileWidget(
      {required this.name,
      required this.appearance,
      this.tooltip,
      this.onDoubleCilck,
      required this.index});

  @override
  State<FileWidget> createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  late double dx;
  late double dy;

  @override
  void initState() {
    super.initState();
    dx = (widget.index % (CommonUtils.mediaQuery.size.width ~/ 105)) * 100;
    dy = (widget.index ~/ (CommonUtils.mediaQuery.size.width ~/ 105)) * 100;
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
    // print(dx);
    // print(dy);
    return Positioned(
        left: dx,
        top: dy,
        child: Draggable(
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            //松手的时候
            moveTO(offset);
          },
          feedback: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blueAccent, width: 0.5))),
          child: GestureDetector(
            child: SizedBox(
              height: 100,
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: null,
                    icon: widget.appearance,
                    tooltip: widget.tooltip ?? "",
                  ),
                  Text(widget.name),
                ],
              ),
            ),
          ),
        ));
  }
}
