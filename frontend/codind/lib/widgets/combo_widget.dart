import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ComboWidget extends StatelessWidget {
  Axis? axis;
  Widget w1;
  Widget w2;
  double? size;
  Function? tapOnW1;
  Function? tapOnW2;
  double? gap;
  ComboWidget(
      {Key? key,
      this.axis,
      required this.w1,
      required this.w2,
      this.size,
      this.tapOnW1,
      this.tapOnW2,
      this.gap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    axis ??= Axis.horizontal;
    size ??= 100;

    if (axis == Axis.horizontal) {
      return SizedBox(
        width: size,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            tapOnW1 == null
                ? w1
                : InkWell(
                    child: w1,
                    onTap: () async => tapOnW1!(),
                  ),
            SizedBox(
              width: gap ?? 5,
            ),
            tapOnW2 == null
                ? w2
                : InkWell(
                    child: w2,
                    onTap: () async => tapOnW2!(),
                  ),
          ],
        ),
      );
    }

    return SizedBox(
      width: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          tapOnW1 == null
              ? w1
              : InkWell(
                  onTap: tapOnW1!(),
                  child: w1,
                ),
          SizedBox(
            height: gap ?? 5,
          ),
          tapOnW2 == null
              ? w2
              : InkWell(
                  onTap: tapOnW2!(),
                  child: w2,
                ),
        ],
      ),
    );
  }
}
