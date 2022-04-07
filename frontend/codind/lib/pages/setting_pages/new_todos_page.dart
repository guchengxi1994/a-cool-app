import 'package:codind/notifications/notification_utils.dart';
import 'package:codind/notifications/notifications.dart';
import 'package:codind/pages/_mobile_base_page.dart';
import 'package:codind/utils/utils.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../widgets/widgets.dart' show CustomListTile;

class NewTodosPage extends MobileBasePage {
  NewTodosPage({Key? key, required pageName, this.time})
      : super(key: key, pageName: pageName);

  TimeOfDay? time;

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _NewTodosPageState();
  }
}

class _NewTodosPageState<T> extends MobileBasePageState<NewTodosPage> {
  final TextStyle _style =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
  late TimeOfDay _time;
  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

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

  @override
  baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomListTile(
            style: _style,
            onTap: () async {
              if (!PlatformUtils.isMobile) {
                showToastMessage("当前平台不支持", context);
                return;
              }

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
                NotificationWeekAndTime _w =
                    NotificationWeekAndTime(dayOfTheWeek: 4, timeOfDay: res);
                await createReminderNotivication(_w);
              }
            },
            title: "Create new todos",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            style: _style,
            title: "Check todos",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
