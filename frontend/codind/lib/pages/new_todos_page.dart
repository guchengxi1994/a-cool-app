import 'package:codind/pages/_mobile_base_page.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart' show CustomListTile;
import '_create_new_todo_page.dart';

class NewTodosPage extends MobileBasePage {
  NewTodosPage({Key? key, required pageName})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _NewTodosPageState();
  }
}

class _NewTodosPageState<T> extends MobileBasePageState<NewTodosPage> {
  final TextStyle _style =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  @override
  void initState() {
    super.initState();
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
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CreateNewTodo();
              }));

              // if (res != null) {
              //   NotificationWeekAndTime _w =
              //       NotificationWeekAndTime(dayOfTheWeek: 4, timeOfDay: res);
              //   await createReminderNotivication(_w);
              // }
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
