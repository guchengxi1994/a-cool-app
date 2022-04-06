/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-22 19:54:23
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-03-22 21:21:19
 */

import 'package:codind/router.dart';
import 'package:codind/widgets/main_page_widgets/radar_chart.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../providers/my_providers.dart';

/// this is for mobile
/// test on web first

class MainPageV2 extends StatefulWidget {
  MainPageV2({Key? key}) : super(key: key);

  @override
  State<MainPageV2> createState() => _MainPageV2State();
}

class _MainPageV2State extends State<MainPageV2> {
  final ScrollController _controller = ScrollController();
  static const double fontSize = 25.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<AngleController>().changeAngle(_controller.offset);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                0.0,
                1.0
              ],
                  colors: [
                Color.fromARGB(255, 223, 211, 195),
                Color.fromARGB(200, 240, 236, 227)
              ])),
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [buildSliverGrid()];
        },
        body: buildBodyCards());
  }

  /// for test
  buildImg(Color color, double height) {
    return SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
        ));
  }

  Widget buildBodyCards() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          if (index == 0) {
            return MainPageCard(
              collapsedWidget: Container(
                height: 100,
                color: const Color.fromARGB(149, 156, 122, 84),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      FlutterI18n.translate(context, "resume.abi"),
                      style: const TextStyle(
                          fontSize: fontSize, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              expanedWidget: const RadarAbilityChart(),
              closeIconColor: Colors.black,
            );
          }

          if (index == 1) {
            return InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(Routers.pageResumePage),
                child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 100,
                    child: Card(
                      color: const Color.fromARGB(150, 199, 177, 152),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            FlutterI18n.translate(context, "resume.title"),
                            style: const TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )));
          }

          return Card(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              color: Colors.red,
              height: 80,
              child: Text(index.toString()),
            ),
          );
        });
  }

  Widget buildSliverGrid() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: null,
      title: null,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // color: Colors.white,
          height: 300,
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: UserAvatarWidget(
                  avatarImg: context.watch<AvatarController>().img,
                  userInfo: "用户A",
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: TodoListWidget(
                        todos: ["当前共有X未完成事项", "当前已完成X事项", "当前有X逾期事项"],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                        child: Row(
                      children: const [
                        Expanded(
                          flex: 1,
                          child: SignupButton(),
                        ),
                        Expanded(
                          flex: 1,
                          child: SettingButton(),
                        )
                      ],
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
