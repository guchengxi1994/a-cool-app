/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-10 21:04:11
 */
import 'package:codind/providers/my_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_page_body.dart';

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
        child: MainPageBody(),
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
