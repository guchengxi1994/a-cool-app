import 'package:flutter/material.dart';
import 'package:taichi/taichi.dart';

class WorkWorkWork {
  int all;
  int done;
  int delayed;
  int underGoing;
  double? width = 80;
  double? height = 160;

  WorkWorkWork(
      {required this.all,
      required this.delayed,
      required this.done,
      required this.underGoing,
      this.width,
      this.height})
      : assert(all == (delayed + done + underGoing) && all > 0);

  List<Color> doneColor = [
    const Color.fromARGB(255, 136, 237, 188),
    Colors.green
  ];

  List<Color> delayColor = [
    const Color.fromARGB(255, 233, 128, 128),
    Colors.red
  ];

  List<Color> underGoingColor = [
    const Color.fromARGB(255, 126, 166, 234),
    Colors.blue
  ];

  final double duration = 3;

  Widget get doneWidget => ProcessLoader.customWaveLoader(
      maxVal: (100 * (done / all)).ceilToDouble(),
      duration: duration,
      width: width ?? 80,
      height: height ?? 160,
      backColor: doneColor[0],
      frontColor: doneColor[1]);

  Widget get delayWidget => ProcessLoader.customWaveLoader(
      maxVal: (100 * (delayed / all)).ceilToDouble(),
      duration: duration,
      width: width ?? 80,
      height: height ?? 160,
      backColor: delayColor[0],
      frontColor: delayColor[1]);

  Widget get underGoingWidget => ProcessLoader.customWaveLoader(
      maxVal: (100 * (underGoing / all)).ceilToDouble(),
      duration: duration,
      width: width ?? 80,
      height: height ?? 160,
      backColor: underGoingColor[0],
      frontColor: underGoingColor[1]);
}
