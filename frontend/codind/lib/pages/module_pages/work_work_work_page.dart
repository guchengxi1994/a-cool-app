/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-07 22:20:26
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-09 21:25:37
 */
import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

import '../base_pages/_mobile_base_page.dart';

// ignore: must_be_immutable
class WorkWorkWorkPage extends MobileBasePage {
  final WorkWorkWork? work;

  WorkWorkWorkPage({Key? key, required pageName, this.work})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _WorkWorkWorkPageState();
  }
}

class _WorkWorkWorkPageState<T> extends MobileBasePageState<WorkWorkWorkPage> {
  late WorkWorkWork work;

  // ignore: prefer_typing_uninitialized_variables
  var _loadDataFuture;

  @override
  void initState() {
    super.initState();

    _loadDataFuture = loadDataBase();
  }

  loadDataBase() async {
    if (widget.work == null) {
      work = await getWorkDays();
    } else {
      work = widget.work!;
    }
  }

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: _loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  work.delayWidget,
                  work.underGoingWidget,
                  work.doneWidget,
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
