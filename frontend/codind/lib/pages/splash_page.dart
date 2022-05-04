/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-04 19:56:02
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-04 20:13:33
 */
import 'package:flutter/material.dart';
import 'package:taichi/taichi.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:provider/provider.dart';
import '../providers/splash_page_provider.dart'
    if (dart.library.html) '../providers/splash_page_web_provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    TaichiFitnessUtil.init(context);
    return Container(
      padding: EdgeInsets.only(top: 0.05 * MediaQuery.of(context).size.height),
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Column(
            children: context.watch<SplashPageScreenController>().done.map((e) {
              int index =
                  context.read<SplashPageScreenController>().done.indexOf(e);
              return TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.1,
                endChild: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          e.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        if (index ==
                            context
                                    .read<SplashPageScreenController>()
                                    .done
                                    .length -
                                1)
                          const CircularProgressIndicator(),
                        if (index <
                            context
                                    .read<SplashPageScreenController>()
                                    .done
                                    .length -
                                1)
                          const Icon(Icons.done, color: Colors.green),
                      ],
                    ),
                  ),
                  // color: Colors.lightGreenAccent,
                ),
              );
            }).toList(),
          ),
          Positioned(
              width: 120,
              right: 10,
              bottom: 10,
              child: Row(
                children: [
                  TaichiAutoRotateGraph.simple(size: 50),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    context.watch<SplashPageScreenController>().value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ))
                ],
              ))
        ],
      ),
    );
  }
}
