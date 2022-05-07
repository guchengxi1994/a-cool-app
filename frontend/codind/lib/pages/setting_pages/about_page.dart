import 'package:codind/_styles.dart';
import 'package:codind/pages/base_pages/_base_stateless_page.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

// ignore: must_be_immutable
class AboutPage extends BaseStatelessPage {
  AboutPage({Key? key, required String pageName})
      : super(key: key, pageName: pageName);

  @override
  baseBuild(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
            height: 50,
          ),
          Image(
            image: AssetImage("assets/icon_no_background.png"),
            height: 80,
            width: 80,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            AppVersion,
            style: AppTheme.aboutPageTextStyle,
          ),
        ],
      ),
    );
  }
}
