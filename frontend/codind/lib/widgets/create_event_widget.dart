import 'package:codind/providers/language_provider.dart';
import 'package:codind/utils/extensions/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// used in ../pages/resume_page.dart
class CreateEventWidget extends StatefulWidget {
  CreateEventWidget({Key? key}) : super(key: key);

  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  DateTime? startTime;
  DateTime? endTime;
  DatetimeSeparator sep = DatetimeSeparator.chinese;

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
                  child: Text(endTime!.toDateString(sep)))
            ],
          ),
        ],
      ),
    );
  }
}
