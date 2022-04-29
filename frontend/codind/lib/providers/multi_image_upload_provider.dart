import 'dart:typed_data';

import 'package:flutter/material.dart';

enum ImgFrom { web, mobile, desktop }

class ImgData {
  ImgFrom? from;
  String? imgname;
  Uint8List? data;

  ImgData({this.data, this.from = ImgFrom.mobile, this.imgname});

  @override
  bool operator ==(Object other) {
    if ((other as ImgData).imgname == null) {
      return false;
    }
    return imgname == (other as ImgData).imgname;
  }
}

class MultiImageUploadController extends ChangeNotifier {
  List<ImgData> _imgList = [];

  List<ImgData> get imgList => _imgList;

  addImg(ImgData img) {
    _imgList.insert(0, img);
    notifyListeners();
  }

  removeImg(String imgname) {
    debugPrint("[remove image name]:$imgname");

    ImgData _data = _imgList.firstWhere(
      (element) => element.imgname == imgname,
      orElse: () => ImgData(imgname: "can not find"),
    );
    _imgList.remove(_data);

    notifyListeners();
  }

  init() {
    _imgList.add(ImgData());
    notifyListeners();
  }
}
