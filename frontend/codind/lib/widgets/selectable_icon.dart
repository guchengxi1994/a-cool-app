import 'package:codind/providers/my_providers.dart'
    show RadioProvider, MainPageCardController;
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '_styles.dart';

@Deprecated("will be removed later")
class SelectableIconButton extends StatefulWidget {
  SelectableIconButton({Key? key, required this.radioValue}) : super(key: key);
  int radioValue;

  @override
  State<SelectableIconButton> createState() => _SelectableIconButtonState();
}

class _SelectableIconButtonState extends State<SelectableIconButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<RadioProvider>().changeValue(widget.radioValue);
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        // padding: const EdgeInsets.only(left: 20, right: 20),
        height: 100,
        // width: 75,
        decoration: BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          //设置四周边框
          border: context.watch<RadioProvider>().value == widget.radioValue
              ? Border.all(width: 1, color: Colors.red)
              : Border.all(width: 1, color: Colors.grey[300]!),
        ),
        child: Stack(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 40, right: 20),
            child: Text(
                context.read<RadioProvider>().mdNames[widget.radioValue] ?? ""),
          ),
          Positioned(
              left: 5,
              top: 5,
              child: Radio(
                value: widget.radioValue,
                groupValue: context.watch<RadioProvider>().value,
                onChanged: (value) {
                  debugPrint("[debug: selectable-icon] : $value");
                  context.read<RadioProvider>().changeValue(value as int);
                },
              ))
        ]),
      ),
    );
  }
}

@Deprecated("will be removed later")
class SelectableIconV2 extends StatefulWidget {
  SelectableIconV2({Key? key, required this.iconStr}) : super(key: key);
  String iconStr;

  @override
  State<SelectableIconV2> createState() => _SelectableIconV2State();
}

class _SelectableIconV2State extends State<SelectableIconV2> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isSelected = context
        .watch<MainPageCardController>()
        .selectedCards
        .contains(widget.iconStr);
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        context.read<MainPageCardController>().changeSelected(widget.iconStr);
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        // padding: const EdgeInsets.only(left: 20, right: 20),
        height: 200,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          //设置四周边框
          border: isSelected
              ? Border.all(width: 1, color: Colors.red)
              : Border.all(width: 1, color: Colors.grey[300]!),
        ),
        child: Stack(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 40, right: 20),
            child: Text(
              FlutterI18n.translate(context, widget.iconStr),
              maxLines: 3,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: _getCircle(isSelected, fill: true),
          )
        ]),
      ),
    );
  }
}

Widget _getCircle(bool selected, {Color? color, bool? fill}) {
  if (selected) {
    if (fill!) {
      return Container(
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: color ?? Colors.red,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          border: Border.all(width: 2, color: color ?? Colors.red),
        ),
      );
    } else {
      return Container();
    }
  } else {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(width: 2, color: Colors.grey[300]!),
      ),
    );
  }
}

/// inspired by best_flutter_ui_templates
class CoolSelectableIcon extends StatefulWidget {
  CoolSelectableIcon({Key? key, this.mainPageCardData, required this.iconStr})
      : super(key: key);
  final MainPageCardData? mainPageCardData;
  String iconStr;
  @override
  State<CoolSelectableIcon> createState() => _CoolSelectableIconState();
}

class _CoolSelectableIconState extends State<CoolSelectableIcon> {
  late MainPageCardData? mainPageCardData;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    mainPageCardData = widget.mainPageCardData;
  }

  @override
  Widget build(BuildContext context) {
    isSelected = context
        .watch<MainPageCardController>()
        .selectedCards
        .contains(widget.iconStr);
    // print(" t1: $isSelected");
    return SizedBox(
      width: 130,
      height: 200,
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color:
                          HexColor(mainPageCardData!.endColor).withOpacity(0.6),
                      offset: const Offset(1.1, 4.0),
                      blurRadius: 8.0),
                ],
                gradient: LinearGradient(
                  colors: <HexColor>[
                    HexColor(mainPageCardData!.startColor),
                    HexColor(mainPageCardData!.endColor),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(54.0),
                ),
              ),
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isSelected = !isSelected;
                  });
                  // print(" t2: $isSelected");
                  context
                      .read<MainPageCardController>()
                      .changeSelected(widget.iconStr);
                  await context.read<MainPageCardController>().record();
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 54, left: 16, right: 16, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, mainPageCardData!.titleTxt),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: ReservedAppTheme.fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.2,
                          color: ReservedAppTheme.white,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                mainPageCardData!.getNotes().join('\n'),
                                style: const TextStyle(
                                  fontFamily: ReservedAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                  color: ReservedAppTheme.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            mainPageCardData!.tip,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: ReservedAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              letterSpacing: 0.2,
                              color: ReservedAppTheme.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: ReservedAppTheme.nearlyWhite.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 35,
              left: 15,
              child: SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(mainPageCardData!.imagePath),
              ),
            ),
          Positioned(
              top: 40, left: 15, child: _getCircle(isSelected, fill: false)),
        ],
      ),
    );
  }
}

class MainPageCardData {
  String titleTxt;
  String startColor;
  String endColor;
  String imagePath;

  MainPageCardData(
      {this.imagePath = "assets/images/Check.png",
      this.endColor = "",
      this.startColor = "",
      this.titleTxt = ""});

  static List<MainPageCardData> generate() {
    return [
      MainPageCardData(
          titleTxt: "label.todos",
          endColor: Color.fromARGB(255, 129, 127, 94).value.toRadixString(16),
          startColor:
              Color.fromARGB(255, 108, 133, 86).value.toRadixString(16)),
      MainPageCardData(
          titleTxt: "resume.abi", endColor: "ff55b941", startColor: "ffb9c242"),
      MainPageCardData(
          titleTxt: "resume.title",
          endColor: Color.fromARGB(255, 23, 110, 106).value.toRadixString(16),
          startColor:
              Color.fromARGB(255, 59, 122, 216).value.toRadixString(16)),
      MainPageCardData(
          titleTxt: "label.friend",
          endColor: Color.fromARGB(255, 128, 141, 29).value.toRadixString(16),
          startColor:
              Color.fromARGB(255, 170, 212, 52).value.toRadixString(16)),
      MainPageCardData(
          titleTxt: "label.md",
          endColor: Color.fromARGB(255, 41, 179, 29).value.toRadixString(16),
          startColor: Color.fromARGB(255, 42, 105, 34).value.toRadixString(16)),
      MainPageCardData(
          titleTxt: "label.kb",
          endColor: Color.fromARGB(255, 51, 60, 109).value.toRadixString(16),
          startColor: Color.fromARGB(255, 33, 37, 140).value.toRadixString(16)),
    ];
  }

  List<String> getNotes() {
    List<String> l = [];
    switch (titleTxt) {
      case "label.todos":
        l = ["早睡早起", "规律作息", "..."];
        break;
      case "resume.abi":
        l = ["好好学习", "实力提升", "..."];
        break;
      case "resume.title":
        l = ["只有你了解你自己", "..."];
        break;
      case "label.friend":
        l = ["同门曰朋", "同志曰友", "..."];
        break;
      case "label.md":
        l = ["Write here", "Write there", "..."];
        break;
      case "label.kb":
        l = ["好记性不如烂笔头", "..."];
        break;
      default:
        l = [];
    }

    return l;
  }

  String get tip => _tip();

  String _tip() {
    String l = "";
    switch (titleTxt) {
      case "label.todos":
        l = "美好的一天";
        break;
      case "resume.abi":
        l = "已超越99%";
        break;
      case "resume.title":
        l = "Wonderful";
        break;
      case "label.friend":
        l = "朋友聚居";
        break;
      case "label.md":
        l = "Enjoy writing";
        break;
      case "label.kb":
        l = "Keep learning";
        break;
      default:
        l = "";
    }

    return l;
  }
}
