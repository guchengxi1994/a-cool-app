/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-11 20:11:27
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-11 21:42:05
 */
import 'package:codind/providers/experience_provider.dart';
import 'package:codind/providers/language_provider.dart';
import 'package:codind/utils/extensions/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// used in ../pages/resume_page.dart
class CreateEventWidget extends StatefulWidget {
  CreateEventWidget({Key? key, required this.index, required this.name})
      : super(key: key);
  String name;
  int index;

  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  DateTime? startTime;
  DateTime? endTime;
  DatetimeSeparator sep = DatetimeSeparator.chinese;
  String result = "";

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    endTime = DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    sep = context.read<LanguageControllerV2>().currentLang == "zh_CN"
        ? DatetimeSeparator.chinese
        : DatetimeSeparator.slash;
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("start time"),
              TextButton(
                  onPressed: () async {
                    showDatePicker(
                            locale: context
                                        .read<LanguageControllerV2>()
                                        .currentLang ==
                                    "zh_CN"
                                ? Locale("zh", "CH")
                                : Locale("en", "US"),
                            context: context,
                            initialDate: startTime!,
                            firstDate: DateTime(1970),
                            lastDate: DateTime(startTime!.year + 20))
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          startTime = value;
                        });
                      }
                    });
                  },
                  child: Text(startTime!.toDateString(sep)))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("end time"),
              TextButton(
                  onPressed: () async {
                    showDatePicker(
                            locale: context
                                        .read<LanguageControllerV2>()
                                        .currentLang ==
                                    "zh_CN"
                                ? Locale("zh", "CH")
                                : Locale("en", "US"),
                            context: context,
                            initialDate: startTime!,
                            firstDate: DateTime(1970),
                            lastDate: DateTime(endTime!.year + 20))
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          endTime = value;
                        });
                      }
                    });
                  },
                  child: Text(endTime!.toDateString(sep))),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            maxLength: 100,
            maxLines: 3,
            decoration: InputDecoration(
              disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 39, 50, 100), width: 3)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 3)),
              suffix: IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  setState(() {
                    context
                        .read<ExperienceController>()
                        .addValue(widget.name, widget.index, result);
                  });
                },
              ),
            ),
            onChanged: (v) {
              result = v;
            },
          )
        ],
      ),
    );
  }
}
