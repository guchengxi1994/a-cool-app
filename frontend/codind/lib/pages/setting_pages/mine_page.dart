/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-21 19:47:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-21 21:55:51
 */
import 'package:codind/globals.dart';
import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/mobile_widgets/qr_scanner_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../_styles.dart';
import '../../utils/platform_utils.dart';
import '../../widgets/widgets.dart';
import 'about_page.dart';
import 'mobile_main_setting_page.dart';

// ignore: must_be_immutable
class MinePage extends MobileBasePage {
  MinePage({Key? key, required String pageName})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _MinePageState();
  }
}

class _MinePageState extends MobileBasePageState<MinePage> {
  @override
  baseBuild(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          CustomListTile(
            nextPage: MobileMainSettingPage(
              pageName: "设置",
            ),
            style: AppTheme.settingPageListTileTitleStyle,
            title: "偏好设置",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            // nextPage: MobileMainSettingPage(
            //   pageName: "设置",
            // ),
            route: Routers.pageIntro,
            style: AppTheme.settingPageListTileTitleStyle,
            title: "查看APP介绍",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          if (PlatformUtils.isMobile)
            const SizedBox(
              height: 10,
            ),
          if (PlatformUtils.isMobile)
            CustomListTile(
              style: AppTheme.settingPageListTileTitleStyle,
              title: "扫码登录桌面端",
              trailing: const Icon(
                Icons.chevron_right,
                size: 25,
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            style: AppTheme.settingPageListTileTitleStyle,
            title: "展示个人二维码",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            style: AppTheme.settingPageListTileTitleStyle,
            onTap: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      // ignore: prefer_const_constructors
                      title: Text("是否打开第三方链接"),
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: () {
                              launchURL(
                                  "https://github.com/guchengxi1994/a-cool-app");
                              Navigator.of(context).pop();
                            },
                            child: Text(FlutterI18n.translate(
                                context, "button.label.ok"))),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(FlutterI18n.translate(
                                context, "button.label.cancel")))
                      ],
                    );
                  });
            },
            title: "访问源码仓库",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            style: AppTheme.settingPageListTileTitleStyle,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AboutPage(
                  pageName: AppName,
                );
              }));
            },
            title: "关于 $AppName",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          if (PlatformUtils.isMobile)
            const SizedBox(
              height: 10,
            ),
          if (PlatformUtils.isMobile)
            CustomListTile(
              style: AppTheme.settingPageListTileTitleStyle,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  var _page = ScanMainPage(type: 1);
                  return _page.getPage();
                }));
              },
              title: "扫码登录桌面版",
              trailing: const Icon(
                Icons.chevron_right,
                size: 25,
              ),
            ),
        ],
      ),
    );
  }
}
