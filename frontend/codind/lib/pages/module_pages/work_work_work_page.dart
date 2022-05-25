// ignore_for_file: unused_element

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
import 'package:taichi/taichi.dart';

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
  late WorkWorkWork work =
      WorkWorkWork(all: 1, delayed: 0, done: 0, underGoing: 1);

  // ignore: prefer_typing_uninitialized_variables
  var _loadDataFuture;

  @override
  void initState() {
    super.initState();

    _loadDataFuture = loadDataBase();
  }

  loadDataBase() async {
    if (widget.work == null) {
      var sqliteUtils = SqliteUtils();
      work = await sqliteUtils.getWorkDays();
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
                  _wrapper(
                    description: "弃我去者，昨日之日不可留",
                    child: work.delayWidget,
                  ),
                  _wrapper(
                      description: "乱我心者，今日之日多烦忧",
                      child: work.underGoingWidget),
                  _wrapper(description: '我们总在怀念过去', child: work.doneWidget),
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

// ignore: camel_case_types, must_be_immutable
class _wrapper extends StatelessWidget {
  _wrapper(
      {Key? key, this.comment, required this.child, required this.description})
      : super(key: key);
  String? comment;
  String description;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: !TaichiDevUtils.isWeb
                      ? const TextStyle(fontFamily: "MaShanZheng", fontSize: 20)
                      : const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(comment ?? "boo freaking hoo")
              ],
            )),
            child
          ],
        ),
      ),
    );
  }
}
