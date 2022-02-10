import 'package:flutter/material.dart';

import '../utils/utils.dart';
import '_base_page.dart';

class MainPageBody extends BasePage {
  MainPageBody({Key? key}) : super(key: key);

  @override
  BasePageState<BasePage> getState() {
    return _MainPageBodyState();
  }
}

class _MainPageBodyState<T> extends BasePageState<MainPageBody> {
  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Wrap(children: [
        Card(
          child: ListTile(
            title: const Text("Start writing"),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageMdEditor);
            },
          ),
        ),
        Card(
          child: ListTile(
            title: const Text("Folder"),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageFolder);
            },
          ),
        )
      ]),
    );
  }
}
