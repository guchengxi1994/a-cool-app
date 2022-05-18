// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-21 19:47:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-17 19:31:49
 */
import 'package:codind/globals.dart';
import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/providers/userinfo_provider.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/mobile_widgets/qr_scanner_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taichi/taichi.dart' show TaichiDevUtils;

import '../../_styles.dart';
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
            onTap: TaichiDevUtils.isMobile
                ? null
                : () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            // ignore: prefer_const_constructors
                            title: Text("请前往移动端查看"),
                            actions: [
                              CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(FlutterI18n.translate(
                                      context, "button.label.ok"))),
                            ],
                          );
                        });
                  },
            route: TaichiDevUtils.isMobile ? Routers.pageIntro : null,
            style: AppTheme.settingPageListTileTitleStyle,
            title: "查看APP介绍",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          // if (TaichiDevUtils.isMobile)
          //   const SizedBox(
          //     height: 10,
          //   ),
          // if (TaichiDevUtils.isMobile)
          //   CustomListTile(
          //     style: AppTheme.settingPageListTileTitleStyle,
          //     title: "扫码登录桌面端",
          //     trailing: const Icon(
          //       Icons.chevron_right,
          //       size: 25,
          //     ),
          //   ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            onTap: () async {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text("个人二维码"),
                      content: Material(
                        child: SizedBox(
                            height: 250,
                            width: 300,
                            child: QrImage(
                              size: 300,
                              data: context
                                  .read<UserinfoController>()
                                  .userData
                                  .toJson()
                                  .toString(),
                            )),
                      ),
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("确定"))
                      ],
                    );
                  });
            },
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
          if (TaichiDevUtils.isMobile)
            const SizedBox(
              height: 10,
            ),
          if (TaichiDevUtils.isMobile)
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
          if (TaichiDevUtils.isMobile)
            CustomListTile(
              style: AppTheme.settingPageListTileTitleStyle,
              title: "备份数据",
              onTap: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("Under construction"),
                        actions: [
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("确定"))
                        ],
                      );
                    });
              },
              trailing: const Icon(
                Icons.chevron_right,
                size: 25,
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              PersistenceStorage ps = PersistenceStorage();
              await ps.setUserEmail("");
              await ps.setUserPassword("");
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routers.pageLogin, (route) => false);
            },
            child: Container(
                height: 50,
                color: Colors.white,
                child: const Center(
                  child: Text(
                    "退出登录",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
