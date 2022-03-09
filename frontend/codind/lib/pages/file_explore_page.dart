import 'dart:convert';

import 'package:codind/entity/file_entity.dart';
import 'package:codind/pages/_loading_page_mixin.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

const double iconSize = 100;

class FileExplorePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  FileExplorePage({Key? key}) : super(key: key);

  @override
  State<FileExplorePage> createState() => _FileExplorePageState();
}

class _FileExplorePageState extends State<FileExplorePage>
    with LoadingPageMixin {
  List<Object> _list = [];
  GlobalKey<_FileExploreStackState> globalKey = GlobalKey();
  late int currentDepth;
  late String currentFatherPath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseLoadingMixinBuild(BuildContext context) {
    EntityFolder? _e =
        ModalRoute.of(context)?.settings.arguments as EntityFolder?;
    // print(_e?.toJson());
    currentDepth = _e == null ? 0 : _e.depth;
    // print(currentDepth);
    if (_e != null) {
      currentFatherPath =
          _e.fatherPath == "" ? "" : _e.fatherPath + "/" + _e.name;
      // print(currentFatherPath);
    } else {
      currentFatherPath = "../root";
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: currentFatherPath == "../root"
            ? null
            : IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Responsive.isRoughMobile(context)
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        centerTitle: true,
        title: Text(
          currentFatherPath,
          style: TextStyle(
              color: Responsive.isRoughMobile(context)
                  ? Colors.white
                  : Colors.black),
        ),
        elevation: Responsive.isRoughMobile(context) ? 4 : 0,
        backgroundColor: Responsive.isRoughMobile(context)
            ? Colors.blueAccent
            : Colors.grey[300],
      ),
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
                // showToastMessage("当前无法完成此操作", null);
                globalKey.currentState!.setState(() {});
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
                                errorText: validateString(text)),
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
                  setState(() {
                    isLoading = true;
                  });
                  await globalKey.currentState!.addAFolder(
                      EntityFolder(
                          name: result,
                          depth: currentDepth,
                          children: [],
                          fatherPath: currentFatherPath),
                      currentFatherPath,
                      currentDepth);
                  setState(() {
                    isLoading = false;
                  });
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
                        title: const Text("输入文件名称（默认以md为后缀）"),
                        content: Material(
                          child: TextField(
                            decoration: InputDecoration(
                                errorText: validateString(text)),
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
                  setState(() {
                    isLoading = true;
                  });
                  if (!isAFile(result as String)) {
                    result += ".md";
                  }
                  // String fath = currentFatherPath.split("/").last;
                  await globalKey.currentState!.addAFile(
                      EntityFile(
                          name: result,
                          depth: currentDepth + 1,
                          fatherPath: currentFatherPath,
                          timestamp: dateTime.toString()),
                      currentFatherPath,
                      currentDepth + 1);
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              icon: const Icon(Icons.file_copy))
        ],
      ),
    );
  }

  String? validateString(String s) {
    if (s.contains("/")) {
      return "不能以'/'命名";
    } else if (s == "root" || s == "..") {
      return "不能命名为'root'或者'..'";
    } else {
      return null;
    }
  }
}

// ignore: must_be_immutable
class FileExploreStack extends StatefulWidget {
  FileExploreStack({Key? key, this.entityFolder}) : super(key: key);
  EntityFolder? entityFolder;

  @override
  State<FileExploreStack> createState() => _FileExploreStackState();
}

class _FileExploreStackState extends State<FileExploreStack> {
  List<Object> _list = [];
  var loadFileFuture;

  PersistenceStorage ps = PersistenceStorage();

  Future addAFolder(EntityFolder e, String fatherPath, int depth) async {
    // var s = await spGetFolderStructure();
    var s = await ps.getFolderStructure();
    // EntityFolder? en = fromJsonToEntityAdd(s, fatherPath, depth, e, s);
    var res = flatten(EntityFolder.fromJson(json.decode(s)));
    var _addFile = e.fatherPath + "/" + e.name;

    res.path.add(_addFile);
    EntityFolder? en = toStructured(res);
    if (en != null) {
      setState(() {
        _list.add(e);
      });
      // await spSetFolderStructure(jsonEncode(en.toJson()));
      await ps.setFolderStructure(jsonEncode(en.toJson()));
    }
  }

  // Future refreshWorkboard() async {
  //   await loadJson();
  // }

  Future addAFile(EntityFile e, String fatherPath, int depth) async {
    // var s = await spGetFolderStructure();
    var s = await ps.getFolderStructure();
    var res = flatten(EntityFolder.fromJson(json.decode(s)));
    var _addFile = e.fatherPath + "/" + e.name;
    // print(_addFile);
    res.files.add(e);
    res.path.add(_addFile);
    EntityFolder? en = toStructured(res);

    if (en != null) {
      setState(() {
        _list.add(e);
      });
      // await spSetFolderStructure(jsonEncode(en.toJson()));
      await ps.setFolderStructure(jsonEncode(en.toJson()));
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.entityFolder == null) {
      loadFileFuture = loadJson();
    }
  }

  Future<void> loadJson() async {
    // String _savedData = await spGetFolderStructure();
    String _savedData = await ps.getFolderStructure();
    _list.clear();
    if (_savedData == "") {
      var snapdata = await DefaultAssetBundle.of(context)
          .loadString("assets/_json_test.json");
      Map<String, dynamic> data = json.decode(snapdata.toString());
      EntityFolder entityFolder = EntityFolder.fromJson(data);
      // print(data);
      var res = flatten(entityFolder);
      _list = entityFolder.children;
      // await spSetFolderStructure(snapdata);
      await ps.setFolderStructure(snapdata);
      // await spSetFolderFlattenStructure(res.path);
      await ps.setFolderFlattenStructure(res.path);
    } else {
      Map<String, dynamic> data = json.decode(_savedData.toString());
      EntityFolder entityFolder = EntityFolder.fromJson(data);
      _list = entityFolder.children;
    }
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

// ignore: must_be_immutable
class FileWidget extends StatefulWidget {
  VoidCallback? onDoubleCilck;
  Icon appearance;
  String name;
  String? tooltip;
  int index;

  FileWidget(
      {Key? key,
      required this.name,
      required this.appearance,
      this.tooltip,
      this.onDoubleCilck,
      required this.index})
      : super(key: key);

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
            onTap: () async {
              debugPrint("aaaaaaaa");
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
