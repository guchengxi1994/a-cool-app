import 'dart:convert';

import 'package:codind/entity/file_entity.dart';
import 'package:codind/pages/_loading_page_mixin.dart';
import 'package:codind/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

const double iconSize = 100;

class FileExplorePage extends StatefulWidget {
  FileExplorePage({Key? key}) : super(key: key);

  @override
  State<FileExplorePage> createState() => _FileExplorePageState();
}

class _FileExplorePageState extends State<FileExplorePage>
    with LoadingPageMixin {
  var loadFileFuture;
  List<Object> _list = [];
  GlobalKey<_FileExploreStackState> globalKey = GlobalKey();
  late int currentDepth;
  late String currentFatherPath;

  @override
  void initState() {
    super.initState();
    loadFileFuture = loadJson();
  }

  Future<void> loadJson() async {
    var snapdata = await DefaultAssetBundle.of(context)
        .loadString("assets/_json_test.json");
    // print(snapdata);
    Map<String, dynamic> data = json.decode(snapdata.toString());
    EntityFolder entityFolder = EntityFolder.fromJson(data);
    // print(data);
    _list = entityFolder.children;
  }

  @override
  Widget baseBuild(BuildContext context) {
    EntityFolder? _e =
        ModalRoute.of(context)?.settings.arguments as EntityFolder?;
    currentDepth = _e == null ? 0 : _e.depth;
    if (_e != null) {
      currentFatherPath = _e.fatherPath == "root"
          ? _e.fatherPath + "/" + _e.name
          : "../" + _e.fatherPath + "/" + _e.name;
    } else {
      currentFatherPath = "root";
    }

    return Scaffold(
      appBar: _e == null
          ? AppBar(
              title: const Text("root"),
              centerTitle: true,
            )
          : AppBar(centerTitle: true, title: Text(currentFatherPath)),
      body: FileExploreStack(
        entityFolder: _e,
        key: globalKey,
      ),
      bottomSheet: buildBottomSheet(),
    );
  }

  Widget buildBottomSheet() {
    return Container(
      color: Colors.grey[300],
      child: Wrap(
        children: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              tooltip: "新建文件夹",
              onPressed: () async {
                String text = "";
                var result = await showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("输入文件夹名称"),
                        content: Material(
                          child: TextField(
                            decoration: InputDecoration(
                                errorText: text == "root" ? "不能命名为root" : null),
                            onChanged: ((value) => text = value),
                          ),
                        ),
                        actions: [
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop(text);
                              },
                              child: Text(FlutterI18n.translate(
                                  context, "button.label.ok"))),
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(FlutterI18n.translate(
                                  context, "button.label.quit"))),
                        ],
                      );
                    });

                if (result != null && result != "") {
                  globalKey.currentState!.addAFolder(EntityFolder(
                      name: result,
                      depth: currentDepth,
                      children: [],
                      fatherPath: currentFatherPath));
                }
              },
              icon: const Icon(Icons.folder_special)),
          IconButton(
              tooltip: "新建文件",
              onPressed: () async {
                String text = "";
                var result = await showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("输入文件夹名称"),
                        content: Material(
                          child: TextField(
                            decoration: InputDecoration(
                                errorText: text == "root" ? "不能命名为root" : null),
                            onChanged: ((value) => text = value),
                          ),
                        ),
                        actions: [
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop(text);
                              },
                              child: Text(FlutterI18n.translate(
                                  context, "button.label.ok"))),
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(FlutterI18n.translate(
                                  context, "button.label.quit"))),
                        ],
                      );
                    });

                if (result != null && result != "") {
                  DateTime dateTime = DateTime.now();
                  globalKey.currentState!.addAFile(EntityFile(
                      name: result,
                      depth: currentDepth,
                      fatherPath: currentFatherPath,
                      timestamp: dateTime.toString()));
                }
              },
              icon: const Icon(Icons.file_copy))
        ],
      ),
    );
  }
}

class FileExploreStack extends StatefulWidget {
  FileExploreStack({Key? key, this.entityFolder}) : super(key: key);
  EntityFolder? entityFolder;

  @override
  State<FileExploreStack> createState() => _FileExploreStackState();
}

class _FileExploreStackState extends State<FileExploreStack> {
  List<Object> _list = [];
  var loadFileFuture;

  void addAFolder(EntityFolder e) {
    setState(() {
      _list.add(e);
    });
  }

  void addAFile(EntityFile e) {
    setState(() {
      _list.add(e);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.entityFolder == null) {
      loadFileFuture = loadJson();
    }
  }

  Future<void> loadJson() async {
    var snapdata = await DefaultAssetBundle.of(context)
        .loadString("assets/_json_test.json");
    Map<String, dynamic> data = json.decode(snapdata.toString());
    EntityFolder entityFolder = EntityFolder.fromJson(data);
    // print(data);
    _list = entityFolder.children;
  }

  @override
  Widget build(BuildContext context) {
    int depth;
    if (widget.entityFolder != null) {
      _list = widget.entityFolder!.children;
      depth = widget.entityFolder!.depth;
      return Stack(
        children: renderFiles(_list, depth),
      );
    } else {
      depth = 0;
      return FutureBuilder(
        future: loadFileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // print(snapshot.data.toString());

            return Stack(
              children: renderFiles(_list, depth),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    }
  }

  List<Widget> renderFiles(List<Object> list, int depth, {String? fatherPath}) {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].runtimeType == EntityFile) {
        widgets.add(FileWidget(
          tooltip: (list[i] as EntityFile).timestamp,
          index: i,
          appearance: const Icon(Icons.file_present),
          name: (list[i] as EntityFile).name,
          onDoubleCilck: () {
            debugPrint("这里要跳转具体的文件");
          },
        ));
      } else {
        EntityFolder _entity = list[i] as EntityFolder;
        widgets.add(FileWidget(
          tooltip: _entity.children.length.toString() + "个文件",
          index: i,
          appearance: const Icon(Icons.folder),
          name: (list[i] as EntityFolder).name,
          onDoubleCilck: () {
            debugPrint("这里要跳转到下一层级文件夹");

            // print(_entity.toJson());
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
                    padding: const EdgeInsets.all(5),
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
