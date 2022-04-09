import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';

@Deprecated("unnecessary")
class MyTimePicker extends StatefulWidget {
  MyTimePicker({Key? key, this.time}) : super(key: key);
  TimeOfDay? time;

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  late TimeOfDay _time;
  @override
  void initState() {
    super.initState();
    if (widget.time != null) {
      _time = TimeOfDay.now()
          .replacing(hour: widget.time!.hour, minute: widget.time!.minute);
    } else {
      _time = TimeOfDay.now();
    }
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return createInlinePicker(
    //   elevation: 1,
    //   value: _time,
    //   onChange: onTimeChanged,
    //   minuteInterval: MinuteInterval.ONE,
    //   iosStylePicker: false,
    //   minHour: 9,
    //   maxHour: 21,
    //   is24HrFormat: false,
    // );
    return ElevatedButton(
        onPressed: () async {
          var res = await Navigator.of(context).push(
            showPicker(
              context: context,
              value: _time,
              onChange: onTimeChanged,
            ),
          );

          print(res);
        },
        child: Text("click"));
  }
}
