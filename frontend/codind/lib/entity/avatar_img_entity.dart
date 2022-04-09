import 'package:codind/entity/enums.dart';
import 'package:flutter/material.dart';

class AvatarImg {
  Color? background;
  String? imgPath;
  String? imgData;
  AvatarType type;

  AvatarImg({required this.type, this.background, this.imgData, this.imgPath});

  @override
  String toString() {
    return "$type   $imgPath";
  }
}
