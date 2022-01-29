import 'package:flutter/material.dart';

class Sidemenu extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Sidemenu({Key? key}) : super(key: key);

  @override
  SidemenuState createState() => SidemenuState();
}

class SidemenuState extends State<Sidemenu> {
  late ScrollController _pageScrollerController;

  @override
  void initState() {
    super.initState();
    _pageScrollerController = ScrollController();
  }

  @override
  void dispose() {
    _pageScrollerController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.lightBlue,
      child: ListView(
        controller: _pageScrollerController,
        shrinkWrap: true, //范围内进行包裹（内容多高ListView就多高）
        physics: const NeverScrollableScrollPhysics(),
        children: [],
      ),
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(String s) {
    return PopupMenuItem(
      child: Text(s),
    );
  }
}

class DrawerListTile extends StatefulWidget {
  const DrawerListTile({
    Key? key,
    required this.id,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final int id;

  @override
  DrawerListTileState createState() => DrawerListTileState();
}

class DrawerListTileState extends State<DrawerListTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onHover: (b) {
          if (b) {
            setState(() {
              isHovered = true;
            });
          } else {
            setState(() {
              isHovered = false;
            });
          }
        },
        onTap: widget.press,
        child: Container(
          color: Colors.lightBlue,
          padding: const EdgeInsets.all(15),
          child: Text(widget.title,
              style: TextStyle(
                  color: Colors.black, fontSize: isHovered ? 20.0 : 15.0)),
        ),
      ),
    );
  }
}
