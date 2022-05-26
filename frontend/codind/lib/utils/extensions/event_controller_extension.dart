import 'package:codind/entity/event_entity.dart';
import 'package:taichi/taichi.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

import '../../_styles.dart';

extension EventControl on EventController {
  Future<void> init() async {
    clearAll();
    SqliteUtils sqliteUtils = SqliteUtils();
    List<EventEntity> list = await sqliteUtils.getAllEvents();

    List<CalendarEventData> result = [];
    for (var e in list) {
      result.add(CalendarEventData(
          title: e.todoName,
          event: e.tid,
          eventStatus: e.eventStatus,
          color: HexColor(e.color),
          startTime: DateTime.parse(e.startTime),
          endTime: DateTime.parse(e.endTime),
          date: DateTime.parse(e.startTime),
          endDate: DateTime.parse(e.endTime)));
    }

    addAll(result);
  }
}
