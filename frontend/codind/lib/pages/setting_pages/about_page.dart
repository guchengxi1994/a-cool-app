import 'package:codind/_styles.dart';
import 'package:codind/pages/base_pages/_base_stateless_page.dart';
import 'package:codind/providers/package_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        children: [
          const SizedBox(
            height: 50,
          ),
          const Image(
            image: AssetImage("assets/icon_no_background.png"),
            height: 80,
            width: 80,
          ),
          const SizedBox(
            height: 20,
          ),
          ChangeNotifierProvider(
            create: (_) => PackageInfoController()..init(),
            builder: (context, _) {
              return Text(
                context.watch<PackageInfoController>().version +
                    context.watch<PackageInfoController>().buildNumber,
                style: AppTheme.aboutPageTextStyle,
              );
            },
          ),
        ],
      ),
    );
  }
}
