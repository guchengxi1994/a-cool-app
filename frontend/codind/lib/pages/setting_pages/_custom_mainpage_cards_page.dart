/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-09 19:03:08
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-12 21:37:50
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codind/providers/my_providers.dart' show MainPageCardController;

import '../../widgets/_styles.dart';
import '../../widgets/selectable_icon.dart';
import '../_mobile_base_page.dart';

class CustomMainpageCardsPage extends MobileBasePage {
  CustomMainpageCardsPage({Key? key})
      : super(
            key: key,
            pageName: "选择想要展示的内容",
            backgroundColor: ReservedAppTheme.white);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _CustomMainpageCardsPageState();
  }
}

class _CustomMainpageCardsPageState<T>
    extends MobileBasePageState<CustomMainpageCardsPage> {
  @override
  baseBuild(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 20, top: 20, left: 20),
      child: Wrap(
        direction: Axis.vertical,
        // alignment: WrapAlignment.start,
        children:
            context.read<MainPageCardController>().selectedCard.keys.map((e) {
          return CoolSelectableIcon(
            iconStr: e,
            mainPageCardData: MainPageCardData.generate()
                .firstWhere((element) => element.titleTxt == e),
          );
        }).toList(),
      ),
    );
  }
}
