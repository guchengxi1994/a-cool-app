/// modified from https://github.com/Im-unk/simple_login_form_flutter_UI/blob/master/lib/Views/login.dart
import 'package:codind/globals.dart';
import 'package:codind/notifications/notifications.dart';
import 'package:codind/pages/_loading_page_mixin.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../entity/entity.dart' show ScheduleNotificationEntity;
import '../utils/utils.dart';

class CreateNewTodo extends StatefulWidget {
  const CreateNewTodo({key}) : super(key: key);

  @override
  _CreateNewTodoState createState() => _CreateNewTodoState();
}

class _CreateNewTodoState extends State<CreateNewTodo> with LoadingPageMixin {
  String selectedTime = "";

  final TextEditingController titleController = TextEditingController();

  final TextEditingController bodyController = TextEditingController();

  late TimeOfDay _time;
  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay.now();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  final paddingSize = 20.0;

  @override
  Widget baseLoadingMixinBuild(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(220),
        child: Stack(
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
            Positioned(
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: leftBackIconSize,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              left: 5,
              top: 5,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: paddingSize),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  decoration: BoxDecoration(
                    // color: Colors.blue[500]!,
                    border: Border.all(color: Colors.blue[500]!),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    selectedTime,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.21),
                ),
                Container(
                  margin: EdgeInsets.only(right: paddingSize),
                  // width: MediaQuery.of(context).size.width * 0.21,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue[500]!, Colors.blue[700]!]),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: InkWell(
                    onTap: () async {
                      var res = await Navigator.of(context).push(
                        showPicker(
                            context: context,
                            value: _time,
                            onChange: onTimeChanged,
                            cancelText: FlutterI18n.translate(
                                context, "button.label.cancel"),
                            okText: FlutterI18n.translate(
                                context, "button.label.ok")),
                      );
                      if (res != null) {
                        setState(() {
                          int hour = (res as TimeOfDay).hour;
                          int min = res.minute;
                          var minstr = min.toString();
                          if (min < 10) {
                            minstr = "0" + minstr;
                          }

                          selectedTime = hour.toString() + " : " + minstr;
                        });
                      }
                    },
                    child: Text(
                      // FlutterI18n.translate(context, "button.label.ok"),
                      "Select a time",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    if (titleController.text == "") {
                      showToastMessage("主题不可为空", context);
                      return;
                    }

                    if (selectedTime == "") {
                      showToastMessage("时间设置不可为空", context);
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
                      timeOfDay: _time,
                      isRepeat: true,
                    );
                    await createReminderNotivication(entity);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
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
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
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
    ));
  }
}
