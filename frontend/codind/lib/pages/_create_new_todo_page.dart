/// modified from https://github.com/Im-unk/simple_login_form_flutter_UI/blob/master/lib/Views/login.dart
import 'package:codind/globals.dart';
import 'package:codind/notifications/notifications.dart';
import 'package:codind/pages/_loading_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../entity/entity.dart' show ScheduleNotificationEntity;
import '../utils/utils.dart';
import '../widgets/widgets.dart'
    show TodoTimepickerWidget, TodoTimepickerWidgetState;

class CreateNewTodo extends StatefulWidget {
  const CreateNewTodo({key}) : super(key: key);

  @override
  _CreateNewTodoState createState() => _CreateNewTodoState();
}

class _CreateNewTodoState extends State<CreateNewTodo> with LoadingPageMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final paddingSize = 20.0;

  GlobalKey<TodoTimepickerWidgetState> globalKey1 = GlobalKey();
  GlobalKey<TodoTimepickerWidgetState> globalKey2 = GlobalKey();

  bool showBack = false;

  String validate() {
    if (titleController.text == "") {
      return "主题不可为空";
    }

    if (globalKey1.currentState!.selectedTime == "") {
      return "开始时间设置不可为空";
    }

    if (globalKey2.currentState!.selectedTime == "") {
      return "结束时间设置不可为空";
    }

    if (timeToDouble(globalKey2.currentState!.time) <
        timeToDouble(globalKey1.currentState!.time)) {
      return "结束时间不可早于开始事件";
    }

    return "";
  }

  double timeToDouble(TimeOfDay t) {
    return t.hour + t.minute / 60.0;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      // print(scrollController.offset);
      if (scrollController.offset > 150) {
        setState(() {
          showBack = true;
        });
      } else {
        showBack = false;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Widget buildSliverRegion() {
    return SliverAppBar(
      floating: true,
      bottom: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: showBack
            ? IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: leftBackIconSize,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        elevation: 0,
        title: Text(
          "测试",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: showBack,
      ),
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      expandedHeight: 220,
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          size: leftBackIconSize,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        children: [
          Container(
            height: 220,
          ),
          Positioned(
            right: -50,
            top: -50,
            width: 250,
            height: 250,
            child: Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "  Create a \n  new todo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Colors.purple[700]!, Colors.pink[700]!])),
            ),
          ),
        ],
      )),
    );
  }

  @override
  Widget baseLoadingMixinBuild(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [buildSliverRegion()];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: paddingSize, right: paddingSize),
                child: Column(
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (rect) => LinearGradient(
                              colors: [Colors.purple[700]!, Colors.pink[700]!])
                          .createShader(rect),
                      child: TextField(
                        controller: titleController,
                        maxLength: 20,
                        decoration: InputDecoration(
                          hintText: "Input notification title",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: paddingSize, right: paddingSize),
                child: Column(
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (rect) => LinearGradient(
                              colors: [Colors.purple[700]!, Colors.pink[700]!])
                          .createShader(rect),
                      child: TextField(
                        maxLength: 30,
                        controller: bodyController,
                        decoration: InputDecoration(
                          hintText: "Input notification content",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // start time
              TodoTimepickerWidget(
                key: globalKey1,
                buttonStr: "Select start time",
              ),

              const SizedBox(
                height: 20,
              ),

              TodoTimepickerWidget(
                key: globalKey2,
                buttonStr: "Select end time",
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      var s = validate();
                      if (s != "") {
                        showToastMessage(s, context);
                        return;
                      }

                      if (!PlatformUtils.isMobile) {
                        showToastMessage("当前平台不支持", context);
                        return;
                      }

                      ScheduleNotificationEntity entity =
                          ScheduleNotificationEntity(
                        notificationId: 21,
                        title: titleController.text,
                        timeOfDay: globalKey1.currentState!.time,
                        isRepeat: true,
                      );
                      await createReminderNotivication(entity);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.blue[700]!, Colors.purple[700]!]),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        FlutterI18n.translate(context, "button.label.ok"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.purple[700]!, Colors.pink[700]!]),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        FlutterI18n.translate(context, "button.label.cancel"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
