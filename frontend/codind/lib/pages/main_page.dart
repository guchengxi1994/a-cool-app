import 'package:codind/pages/_test_page.dart';
import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainStatefulPage extends StatefulWidget {
  const MainStatefulPage({Key? key}) : super(key: key);

  @override
  State<MainStatefulPage> createState() => _MainStatefulPageState();
}

class _MainStatefulPageState extends State<MainStatefulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Responsive.isDesktop(context) ? null : Sidemenu(),
      key: context.read<MenuController>().scaffoldKey,
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
              child: TestPage(),
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
            create: (context) => MenuController(),
          ),
          ChangeNotifierProvider(
            create: (context) => LanguageController(context),
          ),
        ],
        child: const MainStatefulPage(),
      ),
    );
  }
}
