import 'package:codind/providers/my_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class ColorPickerWidget extends StatefulWidget {
  ColorPickerWidget({Key? key, this.currentColor}) : super(key: key);
  Color? currentColor;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor ??
        context.read<ThemeController>().themeData.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(FlutterI18n.translate(context, "label.pickAColor")),
      content: Column(
        children: [
          ColorPicker(
              onColorChanged: (Color value) {
                setState(() {
                  selectedColor = value;
                });
              },
              pickerColor: selectedColor,
              colorPickerWidth: 300,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              paletteType: PaletteType.hsvWithHue,
              labelTypes: const [],
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
              portraitOnly: true),
        ],
      ),
      actions: [
        CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(selectedColor);
            },
            child: Text(FlutterI18n.translate(context, "button.label.ok"))),
        CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text(FlutterI18n.translate(context, "button.label.quit"))),
      ],
    );
  }
}
