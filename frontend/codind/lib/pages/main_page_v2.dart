// ignore_for_file: prefer_const_constructors

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-22 19:54:23
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-09 21:44:07
 */

/// 手机端的主页

import 'package:codind/pages/module_pages/create_things_page.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/shared_preference_utils.dart';
import 'package:codind/utils/common.dart';
import 'package:codind/widgets/main_page_widgets/main_page_collaps_widget.dart';
import 'package:codind/widgets/main_page_widgets/radar_chart.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../providers/my_providers.dart';
import 'module_pages/new_todos_page.dart';
import 'module_pages/work_work_work_page.dart';

class MainPageV2 extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MainPageV2({Key? key}) : super(key: key);

  @override
  State<MainPageV2> createState() => _MainPageV2State();
}

class _MainPageV2State extends State<MainPageV2> {
  final ScrollController _controller = ScrollController();
  late double _position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.addListener(() {
        context.read<AngleController>().changeAngle(_controller.offset);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TaichiFitnessUtil.init(context);
    _position = 380.h;
    return SafeArea(
      child: Scaffold(
        bottomSheet: context.watch<AngleController>().showbar
            ? Container(
                padding: EdgeInsets.only(left: 40.w),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 50.h,
                child: Text(
                  "当前工作台共有${context.watch<MainPageCardController>().selectedCards.length}个项目，"
                  "还有${context.watch<MainPageCardController>().all - context.watch<MainPageCardController>().selectedCards.length}个可选项",
                  maxLines: 2,
                  style: TextStyle(fontSize: 16.sp),
                ),
              )
            : null,
        appBar: context.watch<AngleController>().showbar
            ? AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: null,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    SizedBox(
                      height: 45.h,
                      width: 45.h,
                      child:
                          buildAvatar(context.watch<UserinfoController>().img),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "测试用户的工作台",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                actions: [
                  Container(
                    padding:
                        EdgeInsets.only(top: 5.h, right: 20.w, bottom: 5.h),
                    child: IconButton(
                        onPressed: () {
                          _controller.animateTo(0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.ease);
                        },
                        icon: Icon(
                          Icons.expand,
                          color: Colors.black,
                          size: 35.sp,
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
                  stops: const [
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
        height: height.h,
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
                padding: EdgeInsets.all(5.sp),
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
            margin: EdgeInsets.only(
                left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
            child: Container(
              color: Colors.red,
              height: 80.h,
              child: Text(index.toString()),
            ),
          );
        });
  }

  Widget buildSliverGrid() {
    // debugPrint("[debug position] : $_position");
    return SliverAppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: null,
        pinned: false,
        floating: false,
        title: null,
        expandedHeight: 380.h,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              Row(
                children: [
                  const Expanded(child: _TopicWidget()),
                  Container(
                    margin: EdgeInsets.only(top: 15.h, right: 10.w),
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      onTap: () {
                        _controller.animateTo(_position,
                            duration: Duration(seconds: 1), curve: Curves.ease);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          "assets/images/expand.png",
                          width: 25.w,
                          height: 25.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                // color: Colors.white,
                height: 250.h,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 5.h, bottom: 5.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: UserAvatarWidget(
                        onTap: () async {
                          await showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text("修改用户名"),
                                  actions: [
                                    CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("确定")),
                                    CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("取消")),
                                  ],
                                );
                              });
                        },
                        avatarImg: context.watch<UserinfoController>().img,
                        userInfo: context
                            .watch<UserinfoController>()
                            .userData
                            .userName,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          TodoListWidgetWithProvider(),
                          SizedBox(
                            height: 5.h,
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

class _TopicWidget extends StatelessWidget {
  const _TopicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TopicController()..init(),
      builder: (context, child) {
        return CoolCollapsWidgetWithoutProvider(
          cardName: context.watch<TopicController>().topic,
          frontImgPath: null,
          backImgPath: "assets/images/achievement.png",
          fontSize: 21.sp,
          onTap: () async {
            String result = "";
            var res = await showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text("输入一个topic"),
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
        );
      },
    );
  }
}

class TodoListWidgetWithProvider extends StatelessWidget {
  const TodoListWidgetWithProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider()..init(),
      builder: (context, _) {
        return InkWell(
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return WorkWorkWorkPage(
                pageName: "日程统计",
              );
            }));
          },
          child: SizedBox(
            height: 120.h,
            child: TodoListWidget(
              // ignore: prefer_const_literals_to_create_immutables
              todos: [
                "当前共有${context.read<TodoProvider>().work.underGoing}未完成事项",
                "当前已完成${context.read<TodoProvider>().work.done}事项",
                "当前有${context.read<TodoProvider>().work.delayed}逾期事项"
              ],
            ),
          ),
        );
      },
    );
  }
}
