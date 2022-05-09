// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:codind/utils/platform_utils.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

import '../_styles.dart';
import '../utils/common.dart';
import 'main_page_widgets/main_page_expanded_widget.dart';

// ignore: non_constant_identifier_names
double GAP = (0.75 * CommonUtils.screenW() - 4 * 36) / 5;

class CardWidget extends StatefulWidget {
  final int index;
  CardWidget({Key? key, required this.index}) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
        controller: _controller,
        front: SizedBox(
          height: 500,
          // color: Colors.red,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  child: SizedBox(
                    // color: Colors.green,
                    width: 0.75 * CommonUtils.screenW(),
                    child: Image.asset(
                      "assets/images/ctitle.png",
                      fit: BoxFit.fitWidth,
                    ),
                  )),
              Positioned(
                  bottom: 18,
                  left: 0,
                  child: SizedBox(
                    width: 0.75 * CommonUtils.screenW(),
                    child: Image.asset(
                      "assets/images/bottom.png",
                      fit: BoxFit.fitWidth,
                    ),
                  )),

              /// 头像
              Positioned(
                  top: 0.75 * CommonUtils.screenW() * 0.75,
                  left: 20,
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/smile_face.png"),
                    ),
                  )),
              Positioned(
                top: 0.75 * CommonUtils.screenW() * 0.75 + 60,
                left: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 4,
                      height: 24,
                      child: Container(
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.index.toString(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "这里是邮箱",
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 0.75 * CommonUtils.screenW() * 0.75 + 60 + 40,
                  left: 0,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),

                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        // height: 20,
                        child:
                            const Text("这里是标签", style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  )),

              Positioned(
                  top: 0.75 * CommonUtils.screenW() * 0.75 + 60 + 40,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                          // child: ,
                          ),
                      Text("编辑信息",
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[400])),
                    ],
                  )),
            ],
          ),
        ),
        back: SizedBox(
          width: 0.75 * CommonUtils.screenW(),
          height: 500,
          child: CoolExpandedWidget(
            child: Stack(children: [
              Positioned(
                // padding: const EdgeInsets.only(right: 16),
                right: 16,
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100.0),
                            ),
                            border: Border.all(
                                width: 4,
                                color:
                                    AppTheme.nearlyDarkBlue.withOpacity(0.2)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '1555',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 24,
                                  letterSpacing: 0.0,
                                  color: AppTheme.nearlyDarkBlue,
                                ),
                              ),
                              Text(
                                'Kcal left',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.0,
                                  color: AppTheme.grey.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!PlatformUtils.isWeb)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CustomPaint(
                            painter: CurvePainter(colors: [
                              AppTheme.nearlyDarkBlue,
                              HexColor("#8A98E8"),
                              HexColor("#8A98E8")
                            ], angle: 140 + (360 - 140) * (1.0 - 0.5)),
                            child: SizedBox(
                              width: 108,
                              height: 108,
                            ),
                          ),
                        ),
                      if (PlatformUtils.isWeb)
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          height: 108,
                          width: 108,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppTheme.nearlyDarkBlue)),
                        )
                    ],
                  ),
                ),
              )
            ]),
            reversed: true,
          ),
        ));
  }
}

class CardListWidget extends StatefulWidget {
  final int index;
  CardListWidget({Key? key, required this.index}) : super(key: key);

  @override
  _CardListWidgetState createState() => _CardListWidgetState();
}

class _CardListWidgetState extends State<CardListWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // margin: EdgeInsets.only(left: 20, right: 20),
      width: 66,
      height: 110,
      child: Column(
        children: const [
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 48,
              height: 48,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/smile_face.png"),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "这里是nickname",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
