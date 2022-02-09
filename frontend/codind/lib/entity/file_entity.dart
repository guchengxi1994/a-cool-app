// ignore_for_file: unnecessary_overrides

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-06 09:06:31
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-09 21:28:29
 */

import 'dart:convert';

// import 'package:codind/utils/utils.dart' show showToastMessage;

enum FileType { folder, file }

class CanOperateFiles {
  bool canOperate;
  String? message;
  CanOperateFiles({required this.canOperate, this.message});
}

class EntityFolder {
  String name = "空文件夹";
  List<Object> children = [];
  String fatherPath = 'root';
  int depth = 0;
  EntityFolder(
      {required this.name,
      required this.depth,
      required this.children,
      required this.fatherPath});

  CanOperateFiles addFile(Object fileOrFolder, {bool? force}) {
    if (fileOrFolder.runtimeType != EntityFile &&
        fileOrFolder.runtimeType != EntityFolder) {
      return CanOperateFiles(canOperate: false, message: "Cannot operate");
    }
    if (force != null) {
      if (force) {
        if (!children.contains(fileOrFolder)) {
          children.add(fileOrFolder);
        } else {
          children.remove(fileOrFolder);
          children.add(fileOrFolder);
        }
      } else {
        if (!children.contains(fileOrFolder)) {
          children.add(fileOrFolder);
        } else {
          if (fileOrFolder.runtimeType == EntityFolder) {
            EntityFolder _en =
                children.firstWhere((element) => element == fileOrFolder)
                    as EntityFolder;
            _en.children.addAll((fileOrFolder as EntityFolder).children);
            children.remove(fileOrFolder);
            children.add(_en);
          } else {
            children.remove(fileOrFolder);
            children.add(fileOrFolder);
          }
        }
      }

      return CanOperateFiles(canOperate: true, message: "");
    }

    if (!children.contains(fileOrFolder)) {
      children.add(fileOrFolder);
      return CanOperateFiles(canOperate: true, message: "");
    } else {
      return CanOperateFiles(
          canOperate: false, message: "Already has same file/folder");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['children'] = children.map((v) {
      // return v.toJson();
      if (v.runtimeType == EntityFolder) {
        return (v as EntityFolder).toJson();
      } else {
        return (v as EntityFile).toJson();
      }
    }).toList();
    data['depth'] = depth;
    data['fatherPath'] = fatherPath;
    return data;
  }

  bool get hasChildren => children.isNotEmpty;

  EntityFolder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        if ((v as Map<String, dynamic>).containsKey("timestamp")) {
          children.add(EntityFile.fromJson(v));
        } else {
          children.add(EntityFolder.fromJson(v));
        }
      });
    }
    depth = json['depth'];
    fatherPath = json['fatherPath'];
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == EntityFolder) {
      return (other as EntityFolder).name == name && (other).depth == depth;
    } else {
      return false;
    }
  }
}

FlattenObject flatten(EntityFolder entityFolder) {
  var names = _getPath(entityFolder);
  // print(names);
  var files = _getFiles(entityFolder);
  // names = _merge(names);
  return FlattenObject(files: files, path: names);
}

@Deprecated("unnecessary")
List<String> _merge(List<String> names) {
  List<String> results = [];

  for (String i in names) {
    if (i.endsWith(".md")) {
      var _l = i.split("/");
      _l.removeLast();
      var _s = _l.join("/");
      if (!results.contains(_s)) {
        results.add(_s);
      }
    } else {
      results.add(i);
    }
  }

  return results;
}

List<String> _getPath(EntityFolder entityFolder) {
  List<String> names = [];

  for (var i in entityFolder.children) {
    if (i.runtimeType == EntityFile) {
      names.add((i as EntityFile).fatherPath + "/" + i.name);
    } else {
      if (!(i as EntityFolder).hasChildren) {
        var s = i.fatherPath + "/" + i.name;
        names.add(s);
      } else {
        names.addAll(_getPath(i));
      }
    }
  }

  return names;
}

List<EntityFile> _getFiles(EntityFolder entityFolder) {
  List<EntityFile> names = [];

  if (entityFolder.hasChildren) {
    for (var i in entityFolder.children) {
      if (i.runtimeType == EntityFile) {
        names.add(i as EntityFile);
      } else {
        if (!(i as EntityFolder).hasChildren) {
          continue;
        } else {
          names.addAll(_getFiles(i));
        }
      }
    }
  }
  return names;
}

class FlattenObject {
  List<String> path;
  List<EntityFile> files;

  FlattenObject({this.files = const [], this.path = const []});
}

EntityFolder? toStructured(FlattenObject object,
    {String? newPath, EntityFile? newFile}) {
  if (newFile != null) {
    object.path.add(newPath!);
    object.files.add(newFile);
  }

  if (newPath != null && !newPath.endsWith(".md")) {
    object.path.add(newPath);
  }

  List<EntityFolder> allFolders = [];

  EntityFolder entityFolder =
      EntityFolder(fatherPath: "", name: "root", children: [], depth: 0);

  allFolders.add(entityFolder);

  // Map<String, dynamic> _json = entityFolder.toJson();
  int maxDepth = 0;
  for (var s in object.path) {
    if (!s.endsWith(".md")) {
      // print(s);
      var slist = s.split("/");
      // slist.remove("..");
      // slist.remove("root");

      for (int i = 2; i < slist.length; i++) {
        EntityFolder _en;
        if (i == 2) {
          _en = EntityFolder(
              name: slist[i],
              depth: i - 1,
              children: [],
              fatherPath: '../root');
          if (maxDepth <= _en.depth) maxDepth = _en.depth;
        } else {
          var name = slist[i];
          var fatherPath = '';
          for (int j = 0; j < i; j++) {
            if (j == 0) {
              fatherPath = fatherPath + slist[j];
            } else {
              fatherPath = fatherPath + "/" + slist[j];
            }
          }
          _en = EntityFolder(
              name: name, depth: i - 1, children: [], fatherPath: fatherPath);
          if (maxDepth <= _en.depth) maxDepth = _en.depth;
        }
        if (!allFolders.contains(_en)) allFolders.add(_en);
      }
    }
  }
  // print(allFolders.length);

  Map<int, List<EntityFolder>> _depthEntityMap = {};
  _depthEntityMap[0] = [entityFolder];

  for (int i = 1; i <= maxDepth; i++) {
    List<EntityFolder> _res =
        allFolders.where((element) => element.depth == i).toList();
    _depthEntityMap[i] = _res;
  }

  print(_depthEntityMap);

  generateFromMap(_depthEntityMap, maxDepth, object.files);
  // print(jsonEncode(_depthEntityMap[0]![0].toJson()));

  return EntityFolder.fromJson(_depthEntityMap[0]![0].toJson());
}

void generateFromMap(Map<int, List<EntityFolder>> depthEntityMap, int maxDepth,
    List<EntityFile> files) {
  for (int index = maxDepth; index > 0; index--) {
    for (var j in depthEntityMap[index]!) {
      for (var i in depthEntityMap[index - 1]!) {
        // var fil = files.firstWhere((element) {
        //   return element.fatherPath.endsWith(j.name);
        // },
        //     orElse: () => EntityFile(
        //         name: "error", timestamp: "", depth: -1, fatherPath: ""));

        // if (fil.name != "error") {
        //   j.children.add(fil);
        //   files.remove(fil);
        // }
        for (var f in files) {
          if (f.fatherPath.endsWith(i.name)) {
            i.addFile(f);
          }
        }

        if (j.fatherPath.endsWith(i.name)) {
          i.children.add(j);
        }
      }
    }
  }
}

void _addFile(
  EntityFolder father,
  List<String> names,
  List<EntityFile> files,
) {
  if (names.isNotEmpty) {
    var listCopy = names;

    EntityFolder entity = EntityFolder(
        name: listCopy[0],
        depth: father.depth + 1,
        children: [],
        fatherPath: father.name);

    if (!father.children.contains(entity)) {
      father.addFile(entity, force: true);
    }

    if (listCopy.length > 1) {
      listCopy.removeAt(0);
      _addFile(entity, listCopy, files);
    }
  }
}

void _addFileMap(Map<String, dynamic> father, List<String> names) {
  var listCopy = names;
  EntityFolder entity = EntityFolder(
      name: listCopy[0],
      depth: father['depth'] + 1,
      children: [],
      fatherPath: father['name']);
  if (!father['children'].contains(entity.toJson())) {
    father['children'].add(entity.toJson());
  }

  if (listCopy.length > 1) {
    listCopy.removeAt(0);
    _addFileMap(entity.toJson(), listCopy);
  }
}

class EntityFile {
  String name = "新建文档.md";

  /// 实际保存的物理路径
  String? savePath;

  /// 标签
  List<String>? tags;

  int depth = 0;

  String fatherPath = "root";

  String timestamp = "2022-02-07 9:09:10";
  EntityFile(
      {required this.name,
      this.savePath = "",
      this.tags = const [],
      required this.timestamp,
      required this.depth,
      required this.fatherPath});

  EntityFile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    savePath = json['savePath'];
    depth = json['depth'];
    fatherPath = json['fatherPath'];
    timestamp = json['timestamp'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['savePath'] = savePath;
    data['depth'] = depth;
    data['fatherPath'] = fatherPath;
    data['timestamp'] = timestamp;
    data['tags'] = tags;
    return data;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == EntityFile) {
      return (other as EntityFile).name == name && (other).depth == depth;
    } else {
      return false;
    }
  }
}

EntityFolder? fromJsonToEntityAdd(String jsonStr, String fatherPath, int depth,
    Object object, String originJsonStr) {
  if (object.runtimeType != EntityFile && object.runtimeType != EntityFolder) {
    // showToastMessage("输入的类型不符", null);
    return null;
  }

  // print(fatherPath);
  Map<String, dynamic> data = json.decode(jsonStr);
  EntityFolder entityFolder = EntityFolder.fromJson(data);
  if (fatherPath == "root") {
    CanOperateFiles canOperateFiles = entityFolder.addFile(object);
    if (!canOperateFiles.canOperate) {
      // showToastMessage(canOperateFiles.message ?? "error", null);
      return null;
    } else {
      return entityFolder;
    }
  } else {
    String fath = fatherPath.split("/").last;
    // EntityFolder _entity = entityFolder;
    // print("------------------");
    // // // print(entityFolder.toJson());
    // print(fath);
    // print(entityFolder.name);
    // print(depth);
    // print(entityFolder.depth);
    // print("------------------");

    Map<String, dynamic> _data = json.decode(originJsonStr);

    EntityFolder _en = EntityFolder.fromJson(_data);

    originJsonStr = json.encode(_en.toJson());

    if (fath == entityFolder.name && depth == entityFolder.depth + 1) {
      // print("要执行这个!");
      CanOperateFiles canOperateFiles = entityFolder.addFile(object);
      if (!canOperateFiles.canOperate) {
        // showToastMessage(canOperateFiles.message ?? "error", null);
        return null;
      } else {
        // print(jsonStr);
        // print(json.encode(entityFolder.toJson()));
        // print(originJsonStr.contains(jsonStr));
        var _s = originJsonStr.replaceAll(
            jsonStr, json.encode(entityFolder.toJson()));

        // print(_s);
        // print("=====================");

        return EntityFolder.fromJson(json.decode(_s));
      }
    } else {
      var _list =
          entityFolder.children.where((e) => e.runtimeType == EntityFolder);
      for (var j in _list) {
        if (depth == (j as EntityFolder).depth && fatherPath == fath) {
          EntityFolder _j = j;
          CanOperateFiles canOperateFiles = _j.addFile(object);
          if (canOperateFiles.canOperate) {
            entityFolder.children.remove(j);
            entityFolder.children.add(_j);
          } else {
            // showToastMessage(canOperateFiles.message ?? "error", null);
          }
          break;
        } else {
          return fromJsonToEntityAdd(
              jsonEncode((j).toJson()), fath, depth, object, originJsonStr);
        }
      }
      // print(jsonStr);
      // print(json.encode(entityFolder.toJson()));

      String _s = originJsonStr.replaceFirst(
          jsonStr, json.encode(entityFolder.toJson()));
      return EntityFolder.fromJson(json.decode(_s));
    }
  }
}
