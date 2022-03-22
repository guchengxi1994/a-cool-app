import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  UserAvatarWidget({Key? key, required this.imgUrl, required this.userInfo})
      : super(key: key);
  String? imgUrl;
  String? userInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [ClipOval()],
        ),
      ),
    );
  }
}
