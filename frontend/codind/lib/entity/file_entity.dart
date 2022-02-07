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
