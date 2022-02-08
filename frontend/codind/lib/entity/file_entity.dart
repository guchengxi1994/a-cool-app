// ignore_for_file: unnecessary_overrides

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-06 09:06:31
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-06 10:18:37
 */

import 'dart:convert';

// import 'package:codind/utils/utils.dart';

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

  CanOperateFiles addFile(Object fileOrFolder) {
    if (fileOrFolder.runtimeType != EntityFile &&
        fileOrFolder.runtimeType != EntityFolder) {
      return CanOperateFiles(canOperate: false, message: "Cannot operate");
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
      this.savePath,
      this.tags,
      required this.timestamp,
      required this.depth,
      required this.fatherPath});

  EntityFile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    savePath = json['savePath'];
    depth = json['depth'];
    fatherPath = json['fatherPath'];
    timestamp = json['timestamp'];
    tags = json['tags'].cast<String>();
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
    print("输入的类型不符");
    return null;
  }
  // print(jsonStr);
  Map<String, dynamic> data = json.decode(jsonStr);
  EntityFolder entityFolder = EntityFolder.fromJson(data);
  if (fatherPath == "root") {
    CanOperateFiles canOperateFiles = entityFolder.addFile(object);
    if (!canOperateFiles.canOperate) {
      // showToastMessage(canOperateFiles.message ?? "error", null);
      print(canOperateFiles.message ?? "error");
      return null;
    } else {
      return entityFolder;
    }
  } else {
    String fath = fatherPath.split("/").last;
    // EntityFolder _entity = entityFolder;

    if (fath == entityFolder.fatherPath && depth == entityFolder.depth + 1) {
      CanOperateFiles canOperateFiles = entityFolder.addFile(object);
      if (!canOperateFiles.canOperate) {
        // showToastMessage(canOperateFiles.message ?? "error", null);
        print(canOperateFiles.message ?? "error");
        return null;
      } else {
        var _s = originJsonStr.replaceAll(
            jsonStr, json.encode(entityFolder.toJson()));
        return EntityFolder.fromJson(json.decode(_s));
      }
    } else {
      var _list =
          entityFolder.children.where((e) => e.runtimeType == EntityFolder);
      for (var j in _list) {
        if (depth == (j as EntityFolder).depth + 1 && fatherPath == fath) {
          EntityFolder _j = j;
          CanOperateFiles canOperateFiles = _j.addFile(object);
          if (canOperateFiles.canOperate) {
            entityFolder.children.remove(j);
            entityFolder.children.add(_j);
          } else {
            print("error");
          }
          break;
        } else {
          return fromJsonToEntityAdd(
              jsonEncode((j).toJson()), fath, depth, object, originJsonStr);
        }
      }
      print(jsonStr);
      print(json.encode(entityFolder.toJson()));
      Map<String, dynamic> _data = json.decode(originJsonStr);

      print(originJsonStr.contains(jsonStr));

      String _s = originJsonStr.replaceFirst(
          jsonStr, json.encode(entityFolder.toJson()));
      return EntityFolder.fromJson(json.decode(_s));
    }
  }
}
