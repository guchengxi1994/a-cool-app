import 'dart:io';
import 'dart:typed_data';

import 'package:codind/providers/multi_image_upload_provider.dart';
import 'package:codind/utils/platform_utils.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadMultiImageWidget extends StatelessWidget {
  const UploadMultiImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MultiImageUploadController()..init(),
      builder: (context, child) {
        return _UploadMultiImageWidget();
      },
    );
  }
}

// ignore: must_be_immutable
class _UploadMultiImageWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _UploadMultiImageWidget({Key? key}) : super(key: key);

  @override
  _UploadMultiImageWidgetState createState() => _UploadMultiImageWidgetState();
}

class _UploadMultiImageWidgetState extends State<_UploadMultiImageWidget> {
  final ScrollController _controller = ScrollController();

  int imgCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> render(List<ImgData> ls) {
    List<Widget> ws = [];
    for (ImgData l in ls) {
      ws.add(ImageWidgetV2(
        data: l.data,
        isMulti: true,
      ));
    }

    return ws;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: render(context.watch<MultiImageUploadController>().imgList),
        ),
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

// ignore: must_be_immutable
class ImageWidgetV2 extends StatefulWidget {
  ImageWidgetV2({
    Key? key,
    required this.data,
    this.height,
    this.width,
    this.isMulti,
  }) : super(key: key);
  Uint8List? data;
  double? height;
  double? width;
  // for multi-file
  bool? isMulti;

  @override
  State<ImageWidgetV2> createState() => _ImageWidgetV2State();
}

class _ImageWidgetV2State extends State<ImageWidgetV2> {
  late Uint8List? data;
  late String imageName;

  @override
  void initState() {
    data = widget.data;
    imageName = "";
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

                        if (widget.isMulti ?? false) {
                          context
                              .read<MultiImageUploadController>()
                              .removeImg(imageName);
                        }
                      },
                    ),
                  ))
            ])
          : IconButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  if (!PlatformUtils.isWeb) {
                    imageName = result.files.single.path!;
                    File file = File(imageName);
                    data = await file.readAsBytes();

                    setState(() {});
                  } else {
                    data = result.files.first.bytes;
                    imageName = result.files.first.name;

                    setState(() {});
                  }

                  if (widget.isMulti ?? false) {
                    context
                        .read<MultiImageUploadController>()
                        .addImg(ImgData(data: data, imgname: imageName));
                  }
                }
              },
              icon: const Icon(
                Icons.add,
                size: 50,
              )),
    );
  }
}
