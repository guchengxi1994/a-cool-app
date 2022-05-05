import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:taichi/taichi.dart';

import '../../providers/my_providers.dart';
import '../_styles.dart';

class CoolCollapsWidget extends StatelessWidget {
  final String cardName;
  String? backImgPath;
  CoolCollapsWidget({Key? key, required this.cardName, this.backImgPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Padding(
                // padding: const EdgeInsets.only(top: 16, bottom: 16),
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: ReservedAppTheme.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: ReservedAppTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 1.714,
                            child: backImgPath != null
                                ? Image.asset(backImgPath!)
                                : Image.asset("assets/images/back.png"),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 100,
                                  right: 16,
                                  top: 16,
                                ),
                                child: Text(
                                  FlutterI18n.translate(context, cardName),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: ReservedAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    color: ReservedAppTheme.nearlyDarkBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 100,
                              bottom: 12,
                              top: 4,
                              right: 16,
                            ),
                            child: Text(
                              context
                                  .read<MainPageCardController>()
                                  .getContent(cardName),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: ReservedAppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                letterSpacing: 0.0,
                                color: ReservedAppTheme.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -16,
                right: 20,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: context
                              .read<MainPageCardController>()
                              .getImgPath(cardName) !=
                          null
                      ? Image.asset(
                          context
                              .read<MainPageCardController>()
                              .getImgPath(cardName)!,
                        )
                      : Image.asset(
                          "assets/images/smile_face.png",
                        ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CoolCollapsWidgetWithoutProvider extends StatelessWidget {
  CoolCollapsWidgetWithoutProvider(
      {Key? key,
      required this.frontImgPath,
      this.backImgPath,
      required this.cardName,
      this.fontSize,
      this.imgSize,
      this.onTap})
      : super(key: key);
  String? frontImgPath;
  final String cardName;
  String? backImgPath;
  double? fontSize;
  double? imgSize;
  final onTap;

  @override
  Widget build(BuildContext context) {
    TaichiFitnessUtil.init(context);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.h,
        ),
        Container(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 0, bottom: 0),
          child: onTap != null
              ? InkWell(
                  onTap: () => onTap(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        // padding: const EdgeInsets.only(top: 16, bottom: 16),
                        padding: const EdgeInsets.only(top: 16, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ReservedAppTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: ReservedAppTheme.grey.withOpacity(0.4),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                child: SizedBox(
                                  height: 74.h,
                                  child: AspectRatio(
                                    aspectRatio: 1.714,
                                    child: backImgPath != null
                                        ? Image.asset(backImgPath!)
                                        : Image.asset("assets/images/back.png"),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 120.w,
                                          // right: 16,
                                          top: 25.h,
                                        ),
                                        child: Text(
                                          cardName,
                                          maxLines: 2,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily:
                                                ReservedAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: fontSize ?? 18.5,
                                            letterSpacing: 0.0,
                                            color:
                                                ReservedAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (frontImgPath != null)
                        Positioned(
                          top: -16.h,
                          right: 20.w,
                          child: SizedBox(
                            width: imgSize ?? 80.sp,
                            height: imgSize ?? 80.sp,
                            child: Image.asset(
                              frontImgPath!,
                            ),
                          ),
                        )
                    ],
                  ),
                )
              : Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Padding(
                      // padding: const EdgeInsets.only(top: 16, bottom: 16),
                      padding: const EdgeInsets.only(top: 16, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ReservedAppTheme.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: ReservedAppTheme.grey.withOpacity(0.4),
                                offset: Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              child: SizedBox(
                                height: 74,
                                child: AspectRatio(
                                  aspectRatio: 1.714,
                                  child: backImgPath != null
                                      ? Image.asset(backImgPath!)
                                      : Image.asset("assets/images/back.png"),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 120,
                                        // right: 16,
                                        top: 25,
                                      ),
                                      child: Text(
                                        cardName,
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: ReservedAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: fontSize ?? 18.5,
                                          letterSpacing: 0.0,
                                          color:
                                              ReservedAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (frontImgPath != null)
                      Positioned(
                        top: -16,
                        right: 20,
                        child: SizedBox(
                          width: imgSize ?? 80,
                          height: imgSize ?? 80,
                          child: Image.asset(
                            frontImgPath!,
                          ),
                        ),
                      )
                  ],
                ),
        ),
      ],
    );
  }
}
