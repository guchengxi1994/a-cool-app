/*
 * @Descripttion: for format code
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-04 10:27:53
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-04 10:42:57
 */

import 'dart:convert';

import 'package:codind/entity/file_entity.dart';

void main(List<String> args) {
  var s = """
{
    "name": "root",
    "children": [
        {
            "name": "aaa.md",
            "savePath": "aaa.md",
            "tags": [
                "deep learning",
                "useful tool"
            ],
            "fatherPath": "root",
            "timestamp": "2022-02-07 9:09:10",
            "depth": 0
        },
        {
            "name": "folder_aaa",
            "children": [
                {
                    "name": "bbb.md",
                    "savePath": "bbb.md",
                    "tags": [
                        "deep learning",
                        "useful tool"
                    ],
                    "fatherPath": "folder_aaa",
                    "timestamp": "2022-02-07 9:09:11",
                    "depth": 1
                },
                {
                    "name": "folder_bbb",
                    "children": [
                        {
                            "name": "folder_ccc",
                            "children": [
                                
                            ],
                            "fatherPath": "folder_bbb",
                            "depth": 2
                        }
                    ],
                    "fatherPath": "folder_aaa",
                    "depth": 1
                }
            ],
            "fatherPath": "root",
            "depth": 0
        }
    ],
    "depth": 0,
    "fatherPath": ""
}

""";

  EntityFolder? res = fromJsonToEntityAdd(
      s,
      "../root/folder_aaa/folder_bbb/folder_ccc",
      3,
      EntityFile(
        depth: 3,
        savePath: "./aaa.md",
        fatherPath: 'folder_ccc',
        timestamp: 'aaaa',
        name: '测试的名称-1.md',
      ),
      jsonEncode(jsonDecode(s)));

  print("========================");
  print(json.encode(res?.toJson()));
}
