/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-10 21:52:44
 */
import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_page_body.dart';

@Deprecated("will be removed")
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
            if (Responsive.isRoughDesktop(context)) Sidemenu(),
            Expanded(
                flex: 5,
                child: MainPageBody(
                  routeName: "main",
                ))
          ],
        ),
      ),
    );
  }
}

@Deprecated("will be removed")
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