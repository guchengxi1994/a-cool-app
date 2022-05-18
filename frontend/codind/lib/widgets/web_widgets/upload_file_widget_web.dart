// web by default
// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

@Deprecated("will be removed because `file_picker` supports web now")
class UploadSingleImageWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  UploadSingleImageWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UploadSingleImageWidgetState createState() =>
      _UploadSingleImageWidgetState();
}

// ignore: deprecated_member_use_from_same_package
class _UploadSingleImageWidgetState extends State<UploadSingleImageWidget> {
  final GlobalKey<_ImageWidgetV2State> imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

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

class ImageWidget extends StatefulWidget {
  ImageWidget(
      {Key? key,
      required this.data,
      required this.index,
      this.height,
      this.width,
      required this.imgName,
      this.type})
      : super(key: key);
  Uint8List data;
  int index;
  double? height;
  double? width;
  int? type;
  String imgName;

  @override
  // ignore: library_private_types_in_public_api
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      height: widget.height ?? 150,
      width: widget.width ?? 150,
      child: Stack(
        children: [
          Image.memory(
            widget.data,
            height: widget.height ?? 150,
            width: widget.width ?? 150,
            fit: BoxFit.fill,
          ),
          widget.type == null
              ? Positioned(
                  right: 15,
                  top: 15,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFFF0000), width: 0.5),
                        color: const Color(0xFF9E9E9E),
                        borderRadius: BorderRadius.circular((20.0))),
                    child: IconButton(
                      iconSize: 24,
                      icon: const Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  ))
              : Container()
        ],
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
                await startWebFilePicker();
              },
              icon: const Icon(
                Icons.add,
                size: 50,
              )),
    );
  }

  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files![0];
      // temp_filename = file.name;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result!, file.name);
      });
      reader.readAsDataUrl(file);
    });
  }

  void _handleResult(Object result, String name) {
    debugPrint(name);
    setState(() {
      imageName = name;
      data = const Base64Decoder().convert(result.toString().split(",").last);
    });
  }
}

class UploadMultiImageWidget extends StatefulWidget {
  UploadMultiImageWidget({Key? key, required this.type}) : super(key: key);

  /// type==0 or type==1
  int type;

  @override
  // ignore: library_private_types_in_public_api
  _UploadImageMultiWidgetState createState() => _UploadImageMultiWidgetState();
}

class _UploadImageMultiWidgetState extends State<UploadMultiImageWidget> {
  Uint8List? _bytesData;
  int count = 0;

  List binaryImgs = [];

  @override
  void initState() {
    super.initState();
    // _createCompanyBloc = context.read<CreateCompanyBloc>();

    // _createCompanyBloc.add(AddWidgetEvent(
    //     widget: IconButton(
    //         onPressed: () {
    //           debugPrint("这里来load图片");
    //           if (PlatformUtils.isWeb) {
    //             startWebFilePicker();
    //           } else {
    //             debugPrint("platform 不是 web");
    //           }
    //         },
    //         icon: const Icon(Icons.plus_one))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      child: Row(
        // children: _createCompanyBloc.state.widgets,
        children: const [],
      ),
    );
  }

  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files![0];
      // temp_filename = file.name;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result!, file.name);
      });
      reader.readAsDataUrl(file);
    });
  }

  void _handleResult(Object result, String name) {
    debugPrint(name);
    setState(() {
      _bytesData =
          const Base64Decoder().convert(result.toString().split(",").last);

      binaryImgs.add(_bytesData);

      // ignore: unused_local_variable
      ImageWidget image = ImageWidget(
        data: _bytesData!,
        index: count,
        imgName: name,
      );
      count++;
      // _createCompanyBloc.add(AddWidgetEvent(widget: image));
    });
  }
}
