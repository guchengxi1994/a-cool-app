import 'dart:convert';

import 'package:codind/entity/file_entity.dart';
import 'package:codind/utils/common.dart';
import 'package:flutter/material.dart';

const double iconSize = 100;

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
    EntityFolder? _e =
        ModalRoute.of(context)?.settings.arguments as EntityFolder?;
    int depth;
    // print(_e);
    if (_e == null) {
      depth = 0;
      return Scaffold(
        appBar: AppBar(title: const Text("root")),
        body: FutureBuilder(
          future: loadFileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // print(snapshot.data.toString());
              Map<String, dynamic> data = json.decode(snapshot.data.toString());
              EntityFolder entityFolder = EntityFolder.fromJson(data);
              // print(data);
              return Stack(
                children: renderFiles(entityFolder.children, depth),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      );
    } else {
      depth = _e.depth;
      return Scaffold(
        appBar: AppBar(title: Text(_e.fatherPath + "/" + _e.name)),
        body: Stack(
          children: renderFiles(_e.children, depth),
        ),
      );
    }
  }

  List<Widget> renderFiles(List<Object> list, int depth, {String? fatherPath}) {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].runtimeType == EntityFile) {
        widgets.add(FileWidget(
          index: i,
          appearance: const Icon(Icons.file_present),
          name: (list[i] as EntityFile).name,
          onDoubleCilck: () {
            debugPrint("这里要跳转具体的文件");
          },
        ));
      } else {
        widgets.add(FileWidget(
          index: i,
          appearance: const Icon(Icons.folder),
          name: (list[i] as EntityFolder).name,
          onDoubleCilck: () {
            debugPrint("这里要跳转到下一层级文件夹");
            EntityFolder _entity = list[i] as EntityFolder;
            print(_entity.toJson());
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FileExplorePage(),
                  settings: RouteSettings(arguments: _entity)),
            );
          },
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
    dx = (widget.index %
            (CommonUtils.mediaQuery.size.width ~/ (iconSize + 10))) *
        iconSize;
    dy = (widget.index ~/
            (CommonUtils.mediaQuery.size.width ~/ (iconSize + 10))) *
        iconSize;
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
              height: iconSize,
              width: iconSize,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blueAccent, width: 0.5))),
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onDoubleTap: () => widget.onDoubleCilck!(),
            onTap: () {
              print("aaaaaaaa");
            },
            child: Container(
              color: Colors.transparent,
              height: iconSize,
              width: iconSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Tooltip(
                    message: widget.tooltip ?? "",
                    child: widget.appearance,
                  ),
                  Text(widget.name),
                ],
              ),
            ),
          ),
        ));
  }
}
