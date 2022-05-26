// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:codind/pages/mixins/_background_color_mixin.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/main_page_widgets/main_page_collaps_widget.dart';
import 'package:codind/widgets/mobile_widgets/upload_file_widget.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:codind/utils/no_web/mobile_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/web_utils.dart'
    show saveFile;
import 'package:path_provider/path_provider.dart';
import 'package:taichi/taichi.dart' show TaichiDevUtils;

import '../../_styles.dart';

const bigSize = 25.0;
const smallSize = 20.0;

class ResumePage extends StatefulWidget {
  const ResumePage({Key? key}) : super(key: key);

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> with BackgroundColorMixin {
  late ExpandedColumnWidget educationColumnWidget;
  late ExpandedColumnWidget workColumnWidget;
  late ExpandedColumnWidget skillsColumnWidget;
  final GlobalKey<ExpandedColumnWidgetState> keyEdu = GlobalKey();
  final GlobalKey<ExpandedColumnWidgetState> keyWork = GlobalKey();
  final GlobalKey<ExpandedColumnWidgetState> keySkills = GlobalKey();
  final GlobalKey<UploadSingleImageWidgetState> imgKey = GlobalKey();
  Uint8List? uint8list;

  @override
  void initState() {
    super.initState();
    educationColumnWidget = ExpandedColumnWidget(
      name: "edu",
      key: keyEdu,
    );
    workColumnWidget = ExpandedColumnWidget(
      name: "work",
      key: keyWork,
    );
    skillsColumnWidget = ExpandedColumnWidget(
      name: "abi",
      key: keySkills,
    );
  }

  @override
  baseBackgroundBuild(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, "resume.title"),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: AppTheme.leftBackIconSize,
              color: Color.fromARGB(255, 78, 63, 63),
            )),
        actions: [
          IconButton(
              onPressed: () async {
                FilePickerResult? result;

                if (TaichiDevUtils.isWeb) {
                  result = await FilePicker.platform.pickFiles(
                      allowedExtensions: ["resume"], type: FileType.custom);
                } else {
                  var dir = await getApplicationSupportDirectory();
                  debugPrint("initial path : ${dir.path}");
                  result = await FilePicker.platform.pickFiles(
                      allowedExtensions: ["resume"],
                      initialDirectory: dir.path,
                      type: FileType.custom);
                }

                if (result != null) {
                  String filePath;
                  Uint8List? fileUint8list;
                  if (!TaichiDevUtils.isWeb) {
                    filePath = result.files.single.path!;
                    debugPrint("[file name]: $filePath");
                    File file = File(filePath);
                    fileUint8list = await file.readAsBytes();
                  } else {
                    // filePath = result.files.single.path!;
                    fileUint8list = result.files.first.bytes;
                  }
                  if (fileUint8list != null) {
                    _YourResume yourResume = _YourResume.fromJson(
                        jsonDecode(utf8.decode(fileUint8list)));

                    debugPrint("[debug]: ${yourResume.edu}");

                    keyEdu.currentState!.setMemories(yourResume.edu);
                    keyWork.currentState!.setMemories(yourResume.work);
                    if (yourResume.skills != null &&
                        yourResume.skills!.isNotEmpty) {
                      keySkills.currentState!.setMemories(yourResume.skills!
                          .map((e) => Detais(
                              career: e,
                              end: "2022-05-11",
                              start: "2022-05-11"))
                          .toList());
                    }
                    if (yourResume.imgData != null) {
                      uint8list = base64.decode(yourResume.imgData!);
                      imgKey.currentState!.changeData(uint8list);
                    }
                  }
                }
              },
              icon: const Icon(Icons.file_present,
                  size: AppTheme.leftBackIconSize,
                  color: Color.fromARGB(255, 78, 63, 63))),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Expanded(flex: 4, child: Container()),
                  UploadSingleImageWidget(
                    key: imgKey,
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              MainPageCard(
                expandedMainColor: Colors.grey[100],
                collapsedWidget: CoolCollapsWidgetWithoutProvider(
                  backImgPath: "assets/images/resume.png",
                  frontImgPath: "assets/images/my_edu.png",
                  cardName: FlutterI18n.translate(context, "resume.edu"),
                ),
                expanedWidget: _expandedWidget(context, educationColumnWidget),
                closeIconColor: Colors.red,
              ),
              SizedBox(
                height: 20.h,
              ),
              MainPageCard(
                expandedMainColor: Colors.grey[100],
                collapsedWidget: CoolCollapsWidgetWithoutProvider(
                  backImgPath: "assets/images/resume.png",
                  frontImgPath: "assets/images/my_exp.png",
                  cardName: FlutterI18n.translate(context, "resume.work"),
                ),
                expanedWidget: _expandedWidget(context, workColumnWidget),
                closeIconColor: Colors.red,
              ),
              SizedBox(
                height: 20.h,
              ),
              MainPageCard(
                expandedMainColor: Colors.grey[100],
                collapsedWidget: CoolCollapsWidgetWithoutProvider(
                  backImgPath: "assets/images/resume.png",
                  frontImgPath: "assets/images/my_abi.png",
                  cardName: FlutterI18n.translate(context, "resume.abi"),
                ),
                expanedWidget: _expandedWidget(context, skillsColumnWidget),
                closeIconColor: Colors.red,
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  ElevatedButton(
                      onPressed: () async {
                        var edus = keyEdu.currentState!.getMemories();
                        var works = keyWork.currentState!.getMemories();
                        var skills = keySkills.currentState!.getMemories();

                        debugPrint("[edus ]: $edus");
                        debugPrint("[works ]: $works");
                        debugPrint("[skills ]: $skills");
                        // var imgData =
                        //     context.read<MultiImageUploadController>().imgList;
                        var imgData =
                            imgKey.currentState!.imageKey.currentState!.data;

                        debugPrint("[image length]: ${imgData?.length}");
                        if (imgData != null) {
                          var base64imgData = base64.encode(imgData);
                          _YourResume resume = _YourResume();

                          resume.imgData = base64imgData;
                          resume.edu = edus;
                          resume.skills =
                              skills.map((e) => e.career ?? "").toList();
                          resume.work = works;

                          try {
                            await saveFile(
                                filename: "your_resume.resume",
                                data: json.encode(resume.toJson()));
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        }
                      },
                      child: const Text("确定")),
                  const SizedBox(
                    width: 25,
                  )
                ],
              )
            ],
          )),
    ));
  }
}

Widget _expandedWidget(BuildContext context, ExpandedColumnWidget w) {
  return Container(
    color: Colors.transparent,
    constraints: BoxConstraints(
        minHeight: 100.h, minWidth: MediaQuery.of(context).size.width),
    // child: Card(
    //   child: w,
    // ),
    child: w,
  );
}

class _YourResume {
  String? imgData;
  List<Detais>? edu;
  List<Detais>? work;
  List<String>? skills;

  _YourResume({this.imgData, this.edu, this.work, this.skills});

  _YourResume.fromJson(Map<String, dynamic> json) {
    imgData = json['imgData'];
    if (json['edu'] != null) {
      edu = <Detais>[];
      json['edu'].forEach((v) {
        edu!.add(Detais.fromJson(v));
      });
    }
    if (json['work'] != null) {
      work = <Detais>[];
      json['work'].forEach((v) {
        work!.add(Detais.fromJson(v));
      });
    }
    skills = json['skills'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imgData'] = imgData;
    if (edu != null) {
      data['edu'] = edu!.map((v) => v.toJson()).toList();
    }
    if (work != null) {
      data['work'] = work!.map((v) => v.toJson()).toList();
    }
    data['skills'] = skills;
    return data;
  }
}
