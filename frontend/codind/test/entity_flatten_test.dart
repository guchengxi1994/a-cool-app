import 'dart:convert';

import 'package:codind/entity/file_entity.dart';

void main() {
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
            "depth": 1
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
                    "depth": 2
                },
                {
                    "name": "folder_bbb",
                    "children": [
                        {
                            "name": "folder_ccc",
                            "children": [
                                
                            ],
                            "fatherPath": "folder_bbb",
                            "depth": 3
                        }
                    ],
                    "fatherPath": "folder_aaa",
                    "depth": 2
                }
            ],
            "fatherPath": "root",
            "depth": 1
        }
    ],
    "depth": 0,
    "fatherPath": ""
}

""";

  EntityFolder _en = EntityFolder.fromJson(jsonDecode(s));

  // print(_en.next("folder_ccc", 3));

  var res = flatten(_en);

  // print(res.path);

  toStructured(res);

  // expect(res, res != null);
}
