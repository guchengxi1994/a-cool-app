/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-22 19:54:23
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-13 21:23:24
 */

import 'package:codind/pages/create_things_page.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/shared_preference_utils.dart';
import 'package:codind/widgets/main_page_widgets/main_page_collaps_widget.dart';
import 'package:codind/widgets/main_page_widgets/radar_chart.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../providers/my_providers.dart';
import 'new_todos_page.dart';

/// this is for mobile
/// test on web first

class MainPageV2 extends StatefulWidget {
  MainPageV2({Key? key}) : super(key: key);

  @override
  State<MainPageV2> createState() => _MainPageV2State();
}

class _MainPageV2State extends State<MainPageV2> {
  final ScrollController _controller = ScrollController();

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
    return SafeArea(
      child: Scaffold(
        appBar: context.watch<AngleController>().showbar
            ? AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: null,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: buildAvatar(context.watch<AvatarController>().img),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "测试用户",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                actions: [
                  Container(
                    padding: EdgeInsets.only(top: 5, right: 20, bottom: 5),
                    child: IconButton(
                        onPressed: () {
                          _controller.animateTo(0,
                              duration: Duration(seconds: 1),
                              curve: Curves.ease);
                        },
                        icon: const Icon(
                          Icons.expand,
                          color: Colors.black,
                          size: 35,
                        )),
                  ),
                ],
              )
            : null,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                0.0,
                1.0
              ],
                  colors: [
                // Color.fromARGB(255, 223, 211, 195),
                // Color.fromARGB(200, 240, 236, 227)
                Colors.grey[300]!,
                Colors.grey[100]!,
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
        itemCount: context.watch<MainPageCardController>().selectedCards.length,
        itemBuilder: (context, index) {
          if (context.watch<MainPageCardController>().selectedCards[index] ==
              "resume.abi") {
            return MainPageCard(
              collapsedWidget: CoolCollapsWidget(
                cardName: "resume.abi",
              ),
              expanedWidget: Padding(
                padding: EdgeInsets.all(5),
                child: RadarAbilityChart(),
              ),
              closeIconColor: Colors.black,
            );
          }

          if (context.watch<MainPageCardController>().selectedCards[index] ==
              "resume.title") {
            return InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(Routers.pageResumePage),
                child: CoolCollapsWidget(
                  cardName: "resume.title",
                ));
          }

          if (context.watch<MainPageCardController>().selectedCards[index] ==
              "label.friend") {
            return InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(Routers.pageFriend),
                child: CoolCollapsWidget(
                  cardName: "label.friend",
                ));
          }

          if (context.watch<MainPageCardController>().selectedCards[index] ==
              "label.md") {
            return InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(Routers.pageMdEditor),
                child: CoolCollapsWidget(
                  cardName: "label.md",
                ));
          }

          if (context.watch<MainPageCardController>().selectedCards[index] ==
              "label.todos") {
            return InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewTodosPage(
                      pageName: FlutterI18n.translate(context, "label.todos"),
                    );
                  }));
                },
                child: CoolCollapsWidget(
                  cardName: "label.todos",
                ));
          }

          if (context.watch<MainPageCardController>().selectedCards[index] ==
              "label.kb") {
            return InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    // return NewTodosPage(
                    //   pageName: FlutterI18n.translate(context, "label.kb"),
                    // );
                    return CreateKnowledgeBasePage(
                      pageName: FlutterI18n.translate(context, "label.kb"),
                    );
                  }));
                },
                child: CoolCollapsWidget(
                  cardName: "label.kb",
                ));
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
        pinned: false,
        floating: false,
        title: null,
        expandedHeight: 380,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: CoolCollapsWidgetWithoutProvider(
                    cardName: context.watch<TopicController>().topic,
                    frontImgPath: null,
                    backImgPath: "assets/images/achievement.png",
                    fontSize: 15,
                    onTap: () async {
                      String result = "";
                      var res = await showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("Input a topic"),
                              content: Container(
                                color: Colors.transparent,
                                child: TextField(
                                  maxLength: 10,
                                  onChanged: (v) {
                                    result = v;
                                  },
                                ),
                              ),
                              actions: [
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop(result);
                                    },
                                    child: Text(FlutterI18n.translate(
                                        context, "button.label.ok"))),
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(FlutterI18n.translate(
                                        context, "button.label.cancel"))),
                              ],
                            );
                          });
                      if (res != null) {
                        context.read<TopicController>().changeTopic(res);

                        PersistenceStorage ps = PersistenceStorage();

                        await ps.setTopic(res);
                        await ps.setLastTopicTime(DateTime.now());
                      }
                    },
                  )),
                  Container(
                    margin: EdgeInsets.only(top: 15, right: 10, left: 5),
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      onTap: () {
                        _controller.animateTo(380,
                            duration: Duration(seconds: 1), curve: Curves.ease);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          "assets/images/expand.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                // color: Colors.white,
                height: 250,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: UserAvatarWidget(
                        avatarImg: context.watch<AvatarController>().img,
                        userInfo: "测试用户",
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
            ],
          ),
        ));
  }
}
