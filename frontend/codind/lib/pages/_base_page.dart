import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

abstract class BasePage extends StatefulWidget {
  BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState() {
    // ignore: no_logic_in_create_state
    return getState();
  }

  BasePageState getState();
}

class BasePageState<T extends BasePage> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: baseBuild(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: !Responsive.isDesktop(context)?IconButton(onPressed: (){
          context.read<MenuController>().controlMenu();
        }, icon: icon),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void onCreate() {}
  void onDes() {}
  baseBuild(BuildContext context) {}
}
