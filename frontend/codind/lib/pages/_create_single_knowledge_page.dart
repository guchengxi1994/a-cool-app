/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-12 22:05:46
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-14 22:14:29
 */
import 'package:codind/pages/_knowledge_preview_page.dart';
import 'package:codind/utils/extensions/datetime_extension.dart';
import 'package:codind/widgets/mobile_widgets/upload_file_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/dart.dart' as _dart;
import 'package:highlight/languages/cpp.dart' as _cpp;
import 'package:highlight/languages/rust.dart' as _rust;
import 'package:highlight/languages/python.dart' as _python;
import 'package:highlight/languages/java.dart' as _java;

import '../entity/knowledge_entity.dart';
import '../providers/my_providers.dart';
import '../utils/platform_utils.dart';
import '../widgets/mobile_widgets/qr_scanner_widget.dart';
import '_mobile_base_page.dart';

/// maybe something like a diary
class CreateKnowledgeWidget extends MobileBasePage {
  CreateKnowledgeWidget({Key? key}) : super(key: key, pageName: null);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _CreateKnowledgeWidgetState();
  }
}

class _CreateKnowledgeWidgetState<T>
    extends MobileBasePageState<CreateKnowledgeWidget> {
  late DateTime _time;
  DatetimeSeparator sep = DatetimeSeparator.chinese;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  KnowledgeEntity _knowledgeEntity = KnowledgeEntity();
  String codes = "";
  String currentLang = "选择语言";
  late CodeController _codeController;
  late Mode currentMode;

  List<Mode> languages = [];

  final List<String> _langs = ['Dart', 'C++', 'Rust', 'Python', 'Java'];

  @override
  void initState() {
    super.initState();
    _time = DateTime.now();

    currentMode = _dart.dart;

    languages.add(_dart.dart);
    languages.add(_cpp.cpp);
    languages.add(_rust.rust);
    languages.add(_python.python);
    languages.add(_java.java);

    currentLang = _langs[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _detailController.dispose();
    _codeController.dispose();
    _fromController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    /// title
    /// 时间
    /// 简介（问题简介）
    /// 详情（markdown 或者 plant txt）
    /// 截图？
    /// 代码？
    /// 参考链接地址
    ///
    /// 预览与渲染（markdown?）
    /// 缓存

    _codeController = CodeController(
        text: codes,
        language: currentMode,
        theme: monokaiSublimeTheme,
        onChange: (s) {
          codes = s;
        });
    sep = context.read<LanguageControllerV2>().currentLang == "zh_CN"
        ? DatetimeSeparator.chinese
        : DatetimeSeparator.slash;
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20, bottom: 100, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 60,
                width: 0.5 * MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _titleController,
                  // maxLength: 10,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x00FF0000)),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    hintText: '输入标题',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x00000000)),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                ),
              ),
              Expanded(
                  child: TextButton(
                      onPressed: () async {
                        showDatePicker(
                                locale: context
                                            .read<LanguageControllerV2>()
                                            .currentLang ==
                                        "zh_CN"
                                    ? Locale("zh", "CH")
                                    : Locale("en", "US"),
                                context: context,
                                initialDate: _time,
                                firstDate: DateTime(1970),
                                lastDate: DateTime(_time.year + 20))
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              _time = value;
                            });
                          }
                        });
                      },
                      child: Text(
                        _time.toDateString(sep),
                        style: TextStyle(fontSize: 16),
                      ))),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            constraints: BoxConstraints(
                minHeight: 60, minWidth: MediaQuery.of(context).size.width),
            child: TextField(
              controller: _summaryController,
              // maxLength: 10,
              maxLength: 200,
              maxLines: 5,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00FF0000)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                hintText: '输入简介',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            constraints: BoxConstraints(
                minHeight: 60, minWidth: MediaQuery.of(context).size.width),
            child: TextField(
              controller: _detailController,
              maxLines: null,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00FF0000)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                hintText: '输入详情',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            constraints: BoxConstraints(
                minHeight: 60, minWidth: MediaQuery.of(context).size.width),
            child: CodeField(
                controller: _codeController,
                textStyle: TextStyle(fontFamily: 'SourceCode')),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: DropdownButton(
              hint: Text(currentLang),
              items: [
                DropdownMenuItem(
                  child: Text("Dart"),
                  value: 0,
                ),
                DropdownMenuItem(
                  child: Text("C++"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("Rust"),
                  value: 2,
                ),
                DropdownMenuItem(
                  child: Text("Python"),
                  value: 3,
                ),
                DropdownMenuItem(
                  child: Text("Java"),
                  value: 4,
                ),
              ],
              onChanged: (value) {
                debugPrint("[dropdown-button-value]: $value");
                setState(() {
                  currentLang = _langs[value as int];
                  currentMode = languages[value];
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                height: 60,
                width: 0.8 * MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _fromController,
                  // maxLength: 10,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x00FF0000)),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    hintText: '参考/来源',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x00000000)),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                ),
              ),
              Expanded(
                  child: IconButton(
                onPressed: () {
                  if (PlatformUtils.isMobile) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const ScanMainPage();
                    }));
                  }
                },
                icon: const Icon(Icons.qr_code),
              )),
            ],
          ),
          UploadMultiImageWidget(),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            constraints: BoxConstraints(
                minHeight: 60, minWidth: MediaQuery.of(context).size.width),
            child: TextField(
              controller: _tagController,
              // maxLength: 10,
              maxLength: 100,
              maxLines: 3,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00FF0000)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                hintText: '输入标签（逗号隔开）',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _knowledgeEntity.time = _time.toDateString(sep);
                    _knowledgeEntity.title = _titleController.text;
                    _knowledgeEntity.detail = _detailController.text;
                    _knowledgeEntity.summary = _summaryController.text;
                    _knowledgeEntity.fromUrlOrOthers = _fromController.text;
                    _knowledgeEntity.tag = _tagController.text;
                    _knowledgeEntity.codes = codes;
                    if (codes != "") {
                      _knowledgeEntity.codeStyle = currentLang;
                    }

                    // ignore: prefer_function_declarations_over_variables
                    var tag = () {
                      if (_knowledgeEntity.tag != null) {
                        List<String> ls = _knowledgeEntity.tag!.split(",");

                        String res = "";

                        for (var i in ls) {
                          res += " **$i**  ";
                        }
                        return res;
                      }

                      return "";
                    };

                    String res =
                        """ # ${_knowledgeEntity.title}  \n ### 记录时间： ${_knowledgeEntity.time}  \n ## 摘要 \n  ${_knowledgeEntity.summary} \n   ## 标签 \n ${tag()}  \n   ## 详情  \n  ${_knowledgeEntity.detail} """;

                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text("预览"),
                            content: Container(
                              height: 300,
                              width: 300,
                              child: Markdown(
                                padding: const EdgeInsets.only(bottom: 100),
                                data: res,
                              ),
                            ),
                            actions: [
                              CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(FlutterI18n.translate(
                                      context, "button.label.ok")))
                            ],
                          );
                        });
                  },
                  child: Text("预览")),
              ElevatedButton(
                  onPressed: () {
                    context
                        .read<KnowledgeWidgetController>()
                        .addItem(KnowledgeSummaryWidget(
                          summary: _summaryController.text,
                        ));
                    context
                        .read<KnowledgeController>()
                        .addItem(_knowledgeEntity);
                    Navigator.of(context).pop();
                  },
                  child:
                      Text(FlutterI18n.translate(context, "button.label.ok"))),
            ],
          ),
        ],
      ),
    );
  }
}

class KnowledgeSummaryWidget extends StatelessWidget {
  KnowledgeSummaryWidget({Key? key, required this.summary}) : super(key: key);
  String summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return KnowlegetPreviewPage(
                data: context.read<KnowledgeController>().getOne(summary) ??
                    KnowledgeEntity());
          }));
        },
        child: Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Text(
              summary,
              maxLines: null,
            )),
      ),
    );
  }
}
