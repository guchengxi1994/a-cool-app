import 'package:codind/pages/_background_color_mixin.dart';
import 'package:codind/widgets/mobile_widgets/upload_file_widget.dart'
    if (dart.library.html) 'package:codind/widgets/web_widgets/upload_file_widget_web.dart';
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
            collapsedWidget: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    FlutterI18n.translate(
                      context,
                      "resume.edu",
                    ),
                    style: const TextStyle(fontSize: smallSize),
                  ),
                )),
            expanedWidget: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: 100,
              ),
              child: educationColumnWidget,
            ),
            closeIconColor: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          MainPageCard(
            collapsedWidget: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    FlutterI18n.translate(context, "resume.work"),
                    style: const TextStyle(fontSize: smallSize),
                  ),
                )),
            expanedWidget: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              constraints: BoxConstraints(
                  minHeight: 100, minWidth: MediaQuery.of(context).size.width),
              child: workColumnWidget,
            ),
            closeIconColor: Colors.red,
          ),
          MainPageCard(
            collapsedWidget: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    FlutterI18n.translate(context, "resume.abi"),
                    style: const TextStyle(fontSize: smallSize),
                  ),
                )),
            expanedWidget: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              constraints: BoxConstraints(
                  minHeight: 100, minWidth: MediaQuery.of(context).size.width),
              child: skillsColumnWidget,
            ),
            closeIconColor: Colors.red,
          ),
        ],
      )),
    ));
  }
}
