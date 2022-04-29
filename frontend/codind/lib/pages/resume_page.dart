import 'package:codind/pages/_background_color_mixin.dart';
import 'package:codind/widgets/main_page_widgets/main_page_collaps_widget.dart';
import 'package:codind/widgets/mobile_widgets/upload_file_widget.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../globals.dart';

const bigSize = 25.0;
const smallSize = 20.0;

class ResumePage extends StatefulWidget {
  ResumePage({Key? key}) : super(key: key);

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> with BackgroundColorMixin {
  late ExpandedColumnWidget educationColumnWidget;
  late ExpandedColumnWidget workColumnWidget;
  late ExpandedColumnWidget skillsColumnWidget;

  @override
  void initState() {
    super.initState();
    educationColumnWidget = ExpandedColumnWidget(
      name: "edu",
    );
    workColumnWidget = ExpandedColumnWidget(
      name: "work",
    );
    skillsColumnWidget = ExpandedColumnWidget(
      name: "abi",
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
              fontSize: bigSize,
              fontWeight: FontWeight.bold,
              color: Colors.black),
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
              size: leftBackIconSize,
              color: Color.fromARGB(255, 78, 63, 63),
            )),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(flex: 4, child: Container()),
                  UploadSingleImageWidget(),
                ],
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 20,
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
            ],
          )),
    ));
  }
}

Widget _expandedWidget(BuildContext context, ExpandedColumnWidget w) {
  return Container(
    constraints: BoxConstraints(
        minHeight: 100, minWidth: MediaQuery.of(context).size.width),
    child: Card(
      child: w,
    ),
  );
}
