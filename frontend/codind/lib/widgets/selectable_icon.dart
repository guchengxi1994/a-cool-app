import 'package:codind/providers/my_providers.dart'
    show RadioProvider, MainPageCardController;
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: _getCircle(isSelected),
          )
        ]),
      ),
    );
  }
}

Widget _getCircle(bool selected) {
  if (selected) {
    return Container(
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: Colors.red,
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
        border: Border.all(width: 2, color: Colors.red),
      ),
    );
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
