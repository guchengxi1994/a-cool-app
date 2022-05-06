/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-14 22:06:27
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:codind/entity/knowledge_entity.dart';
import 'package:codind/pages/_base_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '_knowledge_preview_page.dart';

// ignore: must_be_immutable
class TestPage extends BasePage {
  TestPage({Key? key, required String routeName})
      : super(key: key, routeName: routeName);

  @override
  BasePageState<BasePage> getState() {
    return _TestPageState();
  }
}

class _TestPageState<T> extends BasePageState<TestPage> {
  TextEditingController textEditingController = TextEditingController();
  String _savedPath = "";
  @override
  baseBuild(BuildContext context) {
    // return BaseMarkdownPreviewPage(
    //   from: DataFrom.asset,
    //   mdData: "assets/reserved_md_files/markdown_guide.md",
    // );

    String c1 = Color.fromARGB(255, 185, 194, 66).value.toRadixString(16);
    String c2 = Color.fromARGB(255, 85, 185, 65).value.toRadixString(16);

    print(c1);
    print(c2);

    // return Container(
    //   child: CoolSelectableIcon(
    //     mainPageCardData: MainPageCardData(
    //         endColor: c2, startColor: c1, titleTxt: "label.todos"),
    //     iconStr: "label.todos",
    //   ),
    // );

    // return CoolExpandedWidget(
    //   child: RadarAbilityChart(),
    // );

//     return KnowlegetPreviewPage(
//       data: KnowledgeEntity(
//           time: "2022年4月16日", title: "测试", summary: "测试测试测试测试测试测试", detail: """
// 国务院印发的《“十四五”数字经济发展规划》明确提出，鼓励个人利用社交软件、知识分享、音视频网站等新型平台就业创业，促进灵活就业、副业创新。一方面，灵活就业被看作是就业市场的“蓄水池”，为低收入者创造了更多的就业机会，对企业来说则是降本增效的方式。它也意味着对传统雇佣模式的挑战。另一方面，脱离了传统的雇佣模式，零工经济劳动者也面临着保障缺失、不稳定性增强和经济风险加大的困境。

// 去年7 月，多部委连续出台文件，要求加强对平台零工权益的保护，例如强化职业伤害保障，以出行、外卖、即时配送、同城货运等行业的平台企业为重点，组织开展试点。如何维护零工权益，正成为关注的焦点。
// """),
//     );

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Saver'),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "Something",
                    border: OutlineInputBorder()),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                if (!kIsWeb) {
                  if (Platform.isIOS ||
                      Platform.isAndroid ||
                      Platform.isMacOS) {
                    bool status = await Permission.storage.isGranted;

                    if (!status) await Permission.storage.request();
                  }
                }
                List<int> sheets = utf8.encode("测试数据");

                Uint8List data = Uint8List.fromList(sheets);
              },
              child: const Text("Save File")),
          if (!kIsWeb)
            if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)
              ElevatedButton(
                onPressed: () async {
                  List<int> sheets = utf8.encode("测试数据");
                  Uint8List data = Uint8List.fromList(sheets);

                  // String path = await FileSaver.instance.saveAs(
                  //     textEditingController.text == ""
                  //         ? "File"
                  //         : textEditingController.text,
                  //     data,
                  //     "custome123",
                  //     type);
                  // print(path);

                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;

                  try {
                    File _file = File(appDocPath + "/" + "test.file");
                    await _file.writeAsBytes(data);
                  } catch (e) {
                    print(e);
                  }

                  _savedPath = appDocPath + "/" + "test.file";
                },
                child: const Text("Generate Excel and Open Save As Dialog"),
              ),
          ElevatedButton(
              onPressed: () async {
                if (_savedPath != "") {
                  File file = File(_savedPath);
                  var data = await file.readAsString();

                  print(data);
                }
              },
              child: Text("测试"))
        ],
      ),
    );
  }
}

/// The hove page which hosts the calendar
