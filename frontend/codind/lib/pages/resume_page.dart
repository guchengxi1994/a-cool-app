import 'package:codind/widgets/mobile_widgets/upload_file_widget.dart'
    if (dart.library.html) 'package:codind/widgets/web_widgets/upload_file_widget_web.dart';
import 'package:flutter/material.dart';

class ResumePage extends StatefulWidget {
  ResumePage({Key? key}) : super(key: key);

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your Resume"),
            ],
          ),
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
        ],
      )),
    );
  }
}
