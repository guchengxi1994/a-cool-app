// ignore_for_file: deprecated_member_use_from_same_package

import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/pages/module_pages/_create_new_todo_page_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../router.dart';
import '../../widgets/widgets.dart' show CustomListTile;

// ignore: must_be_immutable
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
                return CreateNewTodoV2();
              }));
            },
            title: FlutterI18n.translate(context, "todo.create2"),
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
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageCalendar);
            },
            title: FlutterI18n.translate(context, "todo.check"),
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
