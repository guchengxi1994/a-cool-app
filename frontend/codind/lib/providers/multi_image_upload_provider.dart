// ignore_for_file: no_leading_underscores_for_local_identifiers

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
    return imgname == (other).imgname;
  }

  @override
  int get hashCode => imgname.hashCode;
}

class MultiImageUploadController extends ChangeNotifier {
  // ignore: prefer_final_fields
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
