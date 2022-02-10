/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-10 19:46:16
 */
import 'package:codind/pages/_test_page.dart';
import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '_base_preview_page.dart';
import 'learning_compare_page.dart';
import 'main_page_body.dart';
import 'writing_page.dart';

class MainStatefulPage extends StatefulWidget {
  const MainStatefulPage({Key? key}) : super(key: key);

  @override
  State<MainStatefulPage> createState() => _MainStatefulPageState();
}

class _MainStatefulPageState extends State<MainStatefulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height < 500
                ? 700
                : MediaQuery.of(context).size.height * 1.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              // child: WritingPage(),
              child: MainPageBody(),
              // child: TestPage(),
            )
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LanguageController(context),
          ),
        ],
        child: const MainStatefulPage(),
      ),
    );
  }
}
