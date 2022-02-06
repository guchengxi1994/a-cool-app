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

class FileEntity {
  final String filename;
  final int depth;
  final FileType fileType;
  List<Object> children;
  FileEntity(
      {required this.filename,
      required this.depth,
      this.children = const [],
      required this.fileType});

  CanOperateFiles addFile(Object fileOrFolder) {
    if (fileType == FileType.file) {
      return CanOperateFiles(
          canOperate: false,
          message: "A file cannot contain other files/folders");
    } else {
      if (!children.contains(fileOrFolder)) {
        children.add(fileOrFolder);
        return CanOperateFiles(canOperate: true, message: "");
      } else {
        return CanOperateFiles(
            canOperate: false, message: "Already has same file/folder");
      }
    }
  }
}

class FileEntityFolder {
  final String name;
  FileEntityFolder({required this.name});

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == FileEntityFolder) {
      return (other as FileEntityFolder).name == name;
    } else {
      return false;
    }
  }
}

class FileEntityFile {
  final String name;

  /// 实际保存的物理路径
  String? savePath;

  /// 标签
  List<String>? tags;

  String timestamp;
  FileEntityFile(
      {required this.name, this.savePath, this.tags, required this.timestamp});

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == FileEntityFile) {
      return (other as FileEntityFile).name == name;
    } else {
      return false;
    }
  }
}
