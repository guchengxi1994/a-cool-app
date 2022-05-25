import 'package:codind/entity/entity.dart';
import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/providers/language_provider.dart';
import 'package:codind/utils/extensions/datetime_extension.dart';
import 'package:codind/utils/toast_utils.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:taichi/taichi.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

import '../../widgets/color_picker_widget.dart';

// ignore: must_be_immutable
class CreateNewTodoV2 extends MobileBasePage {
  CreateNewTodoV2({Key? key, this.date}) : super(key: key, pageName: "创建新的日程");

  final DateTime? date;

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _CreateNewTodoV2State();
  }
}

class _CreateNewTodoV2State extends MobileBasePageState<CreateNewTodoV2> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  Color defaultBackgroundColor = Colors.white;
  SqliteUtils sqliteUtils = SqliteUtils();

  late DateTime eventDate = widget.date ?? DateTime.now();
  late DateTime startDate = widget.date ?? DateTime.now();
  late DateTime endDate = DateTime.now();

  double editWidth = 400;
  static const double editHeight = 80;

  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay.fromDateTime(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        editWidth = MediaQuery.of(context).size.width * 0.8;
      });
    });
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  void dispose() {
    _desController.dispose();
    _eventTitleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _buildEventTitle(),
            _buildDate(),
            SizedBox(
              width: editWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_startTime(), _endTime()],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildDes(),
            SizedBox(
              width: editWidth,
              child: Row(
                children: [
                  const Text(
                    "选择颜色",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    // color: defaultBackgroundColor,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.red),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        color: defaultBackgroundColor),
                    height: 40,
                    width: 80,
                    child: InkWell(
                      onTap: () async {
                        Color? selectedColor = await showDialog(
                            context: context,
                            builder: (context) {
                              return ColorPickerWidget(
                                currentColor: defaultBackgroundColor,
                              );
                            });
                        if (null != selectedColor) {
                          setState(() {
                            debugPrint(selectedColor.value.toRadixString(16));
                            defaultBackgroundColor = selectedColor;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE8E8E8),
                      offset: Offset(8, 8),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                width: 120,
                height: 40,
                child: InkWell(
                  onTap: () async {
                    var eventStatus = 0;
                    // String subStr = "";

                    if (!DateTime.now().isBefore(eventDate)) {
                      eventStatus = 2;
                    }

                    // if (DateTime.now().isBefore(eventDate)) {
                    //   subStr = "(进行中)";
                    // } else {
                    //   subStr = "(已延迟)";
                    //   eventStatus = 2;
                    // }

                    if (startDate.isBefore(endDate)) {
                      context.read<EventController>().add(CalendarEventData(
                            eventStatus: eventStatus,
                            title: _eventTitleController.text,
                            date: eventDate,
                            startTime: startDate,
                            endTime: endDate,
                            endDate: eventDate.add(const Duration(
                                hours: 23, minutes: 59, seconds: 59)),
                            description: _desController.text,
                            color: defaultBackgroundColor,
                          ));

                      EventEntity e = EventEntity(
                          description: _desController.text,
                          endTime: endDate.toString(),
                          eventStatus: eventStatus,
                          startTime: startDate.toString(),
                          todoName: _eventTitleController.text,
                          color:
                              defaultBackgroundColor.value.toRadixString(16));
                      await sqliteUtils.insertAnEvent(e);
                      showToastMessage("已创建");
                    } else {
                      showToastMessage("开始时间需小于结束时间");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "创建日程",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTitle() {
    return SizedBox(
      width: editWidth,
      height: editHeight,
      child: Container(
        color: Colors.transparent,

        ///Alignment 用来对齐 Widget
        alignment: const Alignment(0, 0),

        ///文本输入框
        child: TextField(
          ///是否可编辑
          enabled: true,
          controller: _eventTitleController,

          ///用来配置 TextField 的样式风格
          decoration: InputDecoration(
            ///设置输入文本框的提示文字
            ///输入框获取焦点时 并且没有输入文字时
            hintText: "输入Event标题",

            ///设置输入文本框的提示文字的样式
            hintStyle: const TextStyle(
              color: Colors.grey,
              textBaseline: TextBaseline.ideographic,
            ),

            ///输入框内的提示 输入框没有获取焦点时显示
            labelText: "Event Title",
            labelStyle: const TextStyle(color: Colors.blue),

            ///输入文字后面的小图标
            suffixIcon: IconButton(
                onPressed: () {
                  _eventTitleController.text = "";
                },
                icon: const Icon(Icons.close)),

            border: const OutlineInputBorder(
              ///设置边框四个角的弧度
              borderRadius: BorderRadius.all(Radius.circular(10)),

              ///用来配置边框的样式
              borderSide: BorderSide(
                ///设置边框的颜色
                color: Colors.red,

                ///设置边框的粗细
                width: 2.0,
              ),
            ),

            ///设置输入框可编辑时的边框样式
            enabledBorder: const OutlineInputBorder(
              ///设置边框四个角的弧度
              borderRadius: BorderRadius.all(Radius.circular(10)),

              ///用来配置边框的样式
              borderSide: BorderSide(
                ///设置边框的颜色
                color: Colors.blue,

                ///设置边框的粗细
                width: 2.0,
              ),
            ),
            disabledBorder: const OutlineInputBorder(
              ///设置边框四个角的弧度
              borderRadius: BorderRadius.all(Radius.circular(10)),

              ///用来配置边框的样式
              borderSide: BorderSide(
                ///设置边框的颜色
                color: Colors.red,

                ///设置边框的粗细
                width: 2.0,
              ),
            ),

            ///用来配置输入框获取焦点时的颜色
            focusedBorder: const OutlineInputBorder(
              ///设置边框四个角的弧度
              borderRadius: BorderRadius.all(Radius.circular(20)),

              ///用来配置边框的样式
              borderSide: BorderSide(
                ///设置边框的颜色
                color: Colors.green,

                ///设置边框的粗细
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return SizedBox(
      width: editWidth,
      height: editHeight,
      child: Container(
        color: Colors.transparent,

        ///距离顶部
        // margin: const EdgeInsets.only(top: 30),

        ///Alignment 用来对齐 Widget
        alignment: const Alignment(0, 0),

        ///文本输入框
        child: InkWell(
          onTap: () async {
            var res = await showDatePicker(
                context: context,
                initialDate: widget.date ?? DateTime.now(),
                firstDate: widget.date == null
                    ? DateTime.now().subtract(const Duration(days: 20))
                    : widget.date!.subtract(const Duration(days: 20)),
                lastDate: widget.date == null
                    ? DateTime.now().add(const Duration(days: 20))
                    : widget.date!.add(const Duration(days: 20)));
            if (res != null) {
              // ignore: use_build_context_synchronously
              if (context.read<LanguageControllerV2>().currentLang == "zh_CN") {
                _dateController.text =
                    res.toDateString(DatetimeSeparator.chinese);
              } else {
                _dateController.text =
                    res.toDateString(DatetimeSeparator.slash);
              }

              eventDate = res;
              setState(() {});
            }
          },
          child: TextField(
            ///是否可编辑
            enabled: false,
            controller: _dateController,

            ///用来配置 TextField 的样式风格
            decoration: InputDecoration(
              labelText: widget.date == null
                  ? "Event Date"
                  : widget.date!.toDateString(DatetimeSeparator.slash),
              labelStyle: const TextStyle(color: Colors.blue),
              hintText: "选择日期",
              disabledBorder: const OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.blue,

                  ///设置边框的粗细
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatDaytime(TimeOfDay res) {
    int hour = (res).hour;
    int min = res.minute;
    var minstr = min.toString();
    if (min < 10) {
      minstr = "0$minstr";
    }
    return "$hour : $minstr";
  }

  Widget _startTime() {
    return SizedBox(
      width: editWidth * 0.45,
      height: editHeight,
      child: Container(
        color: Colors.transparent,

        ///Alignment 用来对齐 Widget
        alignment: const Alignment(0, 0),

        ///文本输入框
        child: InkWell(
          onTap: () async {
            var res = await Navigator.of(context).push(
              showPicker(
                  context: context,
                  value: _time,
                  onChange: onTimeChanged,
                  cancelText:
                      FlutterI18n.translate(context, "button.label.cancel"),
                  okText: FlutterI18n.translate(context, "button.label.ok")),
            );
            if (res != null) {
              _startTimeController.text = formatDaytime(res);
              startDate = DateTime(eventDate.year, eventDate.month,
                  eventDate.day, (res as TimeOfDay).hour, (res).minute);
              setState(() {});
            }
          },
          child: TextField(
            ///是否可编辑
            enabled: false,
            controller: _startTimeController,

            ///用来配置 TextField 的样式风格
            decoration: const InputDecoration(
              labelText: "Start Time",
              labelStyle: TextStyle(color: Colors.blue),
              hintText: "选择开始时间",
              disabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.blue,

                  ///设置边框的粗细
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _endTime() {
    return SizedBox(
      width: editWidth * 0.45,
      height: editHeight,
      child: Container(
        color: Colors.transparent,

        ///Alignment 用来对齐 Widget
        alignment: const Alignment(0, 0),

        ///文本输入框
        child: InkWell(
          onTap: () async {
            var res = await Navigator.of(context).push(
              showPicker(
                  context: context,
                  value: _time,
                  onChange: onTimeChanged,
                  cancelText:
                      FlutterI18n.translate(context, "button.label.cancel"),
                  okText: FlutterI18n.translate(context, "button.label.ok")),
            );
            if (res != null) {
              _endTimeController.text = formatDaytime(res);
              endDate = DateTime(eventDate.year, eventDate.month, eventDate.day,
                  (res as TimeOfDay).hour, (res).minute);
              setState(() {});
            }
          },
          child: TextField(
            ///是否可编辑
            enabled: false,
            controller: _endTimeController,

            ///用来配置 TextField 的样式风格
            decoration: const InputDecoration(
              labelText: "End Time",
              labelStyle: TextStyle(color: Colors.blue),
              hintText: "选择结束时间",
              disabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),

                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.blue,

                  ///设置边框的粗细
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDes() {
    return SizedBox(
      width: editWidth,
      child: Container(
        color: Colors.transparent,

        ///Alignment 用来对齐 Widget
        alignment: const Alignment(0, 0),

        ///文本输入框
        child: TextField(
          ///是否可编辑
          enabled: true,
          controller: _desController,
          maxLength: 200,
          maxLines: null,

          ///用来配置 TextField 的样式风格
          decoration: InputDecoration(
            ///设置输入文本框的提示文字
            ///输入框获取焦点时 并且没有输入文字时
            hintText: "输入描述内容",

            ///设置输入文本框的提示文字的样式
            hintStyle: const TextStyle(
              color: Colors.grey,
              textBaseline: TextBaseline.ideographic,
            ),

            ///输入框内的提示 输入框没有获取焦点时显示
            labelText: "Description",
            labelStyle: const TextStyle(color: Colors.blue),

            ///输入文字后面的小图标
            suffixIcon: IconButton(
                onPressed: () {
                  _desController.text = "";
                },
                icon: const Icon(Icons.close)),

            border: const OutlineInputBorder(
              ///设置边框四个角的弧度
              borderRadius: BorderRadius.all(Radius.circular(10)),

              ///用来配置边框的样式
              borderSide: BorderSide(
                ///设置边框的颜色
                color: Colors.red,

                ///设置边框的粗细
                width: 2.0,
              ),
            ),

            ///设置输入框可编辑时的边框样式
            enabledBorder: const OutlineInputBorder(
              ///设置边框四个角的弧度
              borderRadius: BorderRadius.all(Radius.circular(10)),

              ///用来配置边框的样式
              borderSide: BorderSide(
                ///设置边框的颜色
                color: Colors.blue,

                ///设置边框的粗细
                width: 2.0,
              ),
            ),
            disabledBorder: const OutlineInputBorder(
              ///设置边框四个角的弧度
              borderRadius: BorderRadius.all(Radius.circular(10)),

              ///用来配置边框的样式
              borderSide: BorderSide(
                ///设置边框的颜色
                color: Colors.red,

                ///设置边框的粗细
                width: 2.0,
              ),
            ),

            ///用来配置输入框获取焦点时的颜色
            focusedBorder: const OutlineInputBorder(
              ///设置边框四个角的弧度
              borderRadius: BorderRadius.all(Radius.circular(20)),

              ///用来配置边框的样式
              borderSide: BorderSide(
                ///设置边框的颜色
                color: Colors.green,

                ///设置边框的粗细
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
