/// modified from https://github.com/Im-unk/simple_login_form_flutter_UI/blob/master/lib/Views/login.dart
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:codind/globals.dart';
import 'package:codind/notifications/notifications.dart';
import 'package:codind/pages/_loading_page_mixin.dart';
import 'package:codind/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

import '../entity/entity.dart' show ScheduleNotificationEntity;
import '../providers/my_providers.dart' show TodoPageScrollController;
import '../utils/utils.dart';
import '../widgets/widgets.dart'
    show TodoTimepickerWidget, TodoTimepickerWidgetState;

class CreateNewTodo extends StatelessWidget {
  const CreateNewTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoPageScrollController(),
        ),
      ],
      child: const _CreateNewTodo(),
    );
  }
}

class _CreateNewTodo extends StatefulWidget {
  const _CreateNewTodo({key}) : super(key: key);

  @override
  _CreateNewTodoState createState() => _CreateNewTodoState();
}

class _CreateNewTodoState extends State<_CreateNewTodo> with LoadingPageMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final paddingSize = 20.0;

  GlobalKey<TodoTimepickerWidgetState> globalKey1 = GlobalKey();
  GlobalKey<TodoTimepickerWidgetState> globalKey2 = GlobalKey();

  bool useNative = true;

  // bool showBack = false;

  static const List<String> types_CN = ["就一次", "我是一个严于律己的人", "往日不再，我只想纪念失去的青春"];

  static const List<String> types_en = [
    "Just once",
    "I am a man of self-discipline",
    "Days gone, I just want to commemorate the past"
  ];

  // int selectTypeIndex = 0;
  String? selectedValue;

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
      context
          .read<TodoPageScrollController>()
          .changeOffset(scrollController.offset);
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
        leading: context.watch<TodoPageScrollController>().showbar
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
        centerTitle: context.watch<TodoPageScrollController>().showbar,
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
                  FlutterI18n.translate(context, "todo.create"),
                  style: const TextStyle(
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
    double _fixedBoundry = MediaQuery.of(context).size.width * 0.4;

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: 200 > _fixedBoundry ? _fixedBoundry : 200),
                      child: Text(
                        FlutterI18n.translate(context, "todo.selectType"),
                        maxLines: 2,
                        style:
                            TextStyle(color: Colors.blue[700]!, fontSize: 20),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                        child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          const Icon(
                            Icons.list,
                            size: 16,
                            color: Colors.yellow,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              FlutterI18n.translate(context, "todo.item"),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: types_CN
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      buttonWidth: 200 > _fixedBoundry ? _fixedBoundry : 200,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        // color: Colors.redAccent,
                        gradient: LinearGradient(
                            colors: [Colors.purple[700]!, Colors.blue[700]!]),
                      ),
                      buttonElevation: 2,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 280,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        // color: Colors.redAccent,
                        gradient: LinearGradient(
                            colors: [Colors.purple[700]!, Colors.blue[700]!]),
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(-20, 0),
                    )),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
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
                        controller: titleController,
                        maxLength: 20,
                        decoration: InputDecoration(
                          hintText:
                              FlutterI18n.translate(context, "todo.input1"),
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
                          hintText:
                              FlutterI18n.translate(context, "todo.input2"),
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
                buttonStr: FlutterI18n.translate(context, "todo.select1"),
              ),

              const SizedBox(
                height: 20,
              ),

              TodoTimepickerWidget(
                key: globalKey2,
                buttonStr: FlutterI18n.translate(context, "todo.select2"),
              ),

              if (PlatformUtils.isMobile)
                const SizedBox(
                  height: 20,
                ),
              if (PlatformUtils.isMobile)
                CheckboxListTile(
                    secondary: Icon(
                      Icons.notifications_active,
                      color: useNative ? Colors.blue : Colors.grey,
                    ),
                    title: Text("使用原生日历提醒(推荐)"),
                    value: useNative,
                    onChanged: (value) {
                      setState(() {
                        useNative = value!;
                      });
                    }),

              const SizedBox(
                height: 40,
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

                      if (!useNative) {
                        ScheduleNotificationEntity entity =
                            ScheduleNotificationEntity(
                          notificationId: 21,
                          title: titleController.text,
                          timeOfDay: globalKey1.currentState!.time,
                          isRepeat: true,
                        );
                        await createReminderNotivication(entity);
                      } else {
                        var today = DateTime.now();
                        Event _event = Event(
                            allDay: false,
                            title: titleController.text,
                            description: bodyController.text,
                            startDate: DateTime(
                                today.year,
                                today.month,
                                today.day,
                                globalKey1.currentState!.time.hour,
                                globalKey1.currentState!.time.minute),
                            endDate: DateTime(
                                today.year,
                                today.month,
                                today.day,
                                globalKey2.currentState!.time.hour,
                                globalKey2.currentState!.time.minute));
                        Add2Calendar.addEvent2Cal(_event);
                      }
                      ScaffoldMessenger.of(Global.navigatorKey.currentContext!)
                          .showSnackBar(SnackBar(
                              content: Text("A notification created")));
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
