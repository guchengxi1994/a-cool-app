import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codind/providers/my_providers.dart' show MainPageCardController;

import '../../widgets/selectable_icon.dart';
import '../_mobile_base_page.dart';

class CustomMainpageCardsPage extends MobileBasePage {
  CustomMainpageCardsPage({Key? key}) : super(key: key, pageName: null);

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
      padding: EdgeInsets.only(bottom: 60, top: 20, left: 20, right: 20),
      child: Wrap(
        alignment: WrapAlignment.start,
        children:
            context.read<MainPageCardController>().selectedCard.keys.map((e) {
          return SelectableIconV2(
            iconStr: e,
          );
        }).toList(),
      ),
    );
  }
}
