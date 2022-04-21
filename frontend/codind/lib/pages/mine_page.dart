/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-21 19:47:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-21 21:55:51
 */
import 'package:codind/pages/_mobile_base_page.dart';
import 'package:flutter/material.dart';

import '../utils/platform_utils.dart';
import '../widgets/widgets.dart';
import 'setting_pages/mobile_main_setting_page.dart';

class MinePage extends MobileBasePage {
  MinePage({Key? key, required String pageName})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _MinePageState();
  }
}

class _MinePageState extends MobileBasePageState<MinePage> {
  final TextStyle _style =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

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
            style: _style,
            title: "偏好设置",
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
              style: _style,
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
            style: _style,
            title: "展示个人二维码",
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
