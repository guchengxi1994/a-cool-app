import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';

import '../base_pages/_mobile_base_page.dart';

// ignore: must_be_immutable
class WorkWorkWorkPage extends MobileBasePage {
  WorkWorkWorkPage({Key? key, required this.work, required pageName})
      : super(key: key, pageName: pageName);
  final WorkWorkWork work;

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _WorkWorkWorkPageState();
  }
}

class _WorkWorkWorkPageState<T> extends MobileBasePageState<WorkWorkWorkPage> {
  late WorkWorkWork work;

  @override
  void initState() {
    super.initState();
    work = widget.work;
  }

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          work.delayWidget,
          work.underGoingWidget,
          work.doneWidget,
        ],
      ),
    );
  }
}
