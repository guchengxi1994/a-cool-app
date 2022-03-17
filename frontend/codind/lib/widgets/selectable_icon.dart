import 'package:codind/providers/my_providers.dart' show RadioProvider;
import 'package:flutter/material.dart';
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
        height: 100,
        width: 75,
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
