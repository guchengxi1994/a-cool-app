import 'package:codind/utils/utils.dart' show PlatformUtils;
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
              icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
