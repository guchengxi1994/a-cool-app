import 'dart:io';
import 'dart:typed_data';

import 'package:codind/utils/utils.dart' show PlatformUtils;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UploadMultiImageWidget extends StatefulWidget {
  UploadMultiImageWidget({Key? key, required this.type}) : super(key: key);

  /// type==0 or type==1
  int type;

  @override
  _UploadMultiImageWidgetNotWebState createState() =>
      _UploadMultiImageWidgetNotWebState();
}

class _UploadMultiImageWidgetNotWebState extends State<UploadMultiImageWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                debugPrint("这里来load图片");
                if (PlatformUtils.isWeb) {
                  debugPrint("platform 是 web");
                } else {
                  debugPrint("platform 不是 web");
                }
              },
              icon: const Icon(Icons.plus_one)),
        ],
      ),
    );
  }
}

class UploadSingleImageWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  UploadSingleImageWidget({Key? key}) : super(key: key);

  @override
  _UploadSingleImageWidgetState createState() =>
      _UploadSingleImageWidgetState();
}

class _UploadSingleImageWidgetState extends State<UploadSingleImageWidget> {
  final GlobalKey<_ImageWidgetV2State> imageKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      width: 160,
      child: ImageWidgetV2(
        key: imageKey,
        data: null,
      ),
    );
  }
}

class ImageWidgetV2 extends StatefulWidget {
  ImageWidgetV2({
    Key? key,
    required this.data,
    this.height,
    this.width,
  }) : super(key: key);
  Uint8List? data;
  double? height;
  double? width;

  @override
  State<ImageWidgetV2> createState() => _ImageWidgetV2State();
}

class _ImageWidgetV2State extends State<ImageWidgetV2> {
  late Uint8List? data;
  late String imageName;

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 150,
      width: widget.width ?? 120,
      decoration: BoxDecoration(
          image: data != null
              ? DecorationImage(image: MemoryImage(data!), fit: BoxFit.cover)
              : null,
          color: const Color.fromARGB(255, 216, 203, 203),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: data != null
          ? Stack(children: [
              Positioned(
                  right: 15,
                  top: 15,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFFF0000), width: 0.5),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular((10.0))),
                    child: IconButton(
                      iconSize: 24,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          data = null;
                        });
                      },
                    ),
                  ))
            ])
          : IconButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  File file = File(result.files.single.path!);
                  data = await file.readAsBytes();
                  setState(() {});
                }
              },
              icon: const Icon(
                Icons.add,
                size: 50,
              )),
    );
  }
}
