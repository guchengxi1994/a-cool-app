// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:codind/entity/entity.dart';
import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:loading_overlay/loading_overlay.dart';
import 'package:taichi/taichi.dart';
import 'package:provider/provider.dart';

import '../base_pages/_mobile_base_page.dart';

/// thanks to "dicebear" and
/// this uses https://avatars.dicebear.com/docs/http-api

const quertStr = "https://avatars.dicebear.com/api/";

class GenerateAvatarPage extends MobileBasePage {
  GenerateAvatarPage({Key? key}) : super(key: key, pageName: null);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _GenerateAvatarPageState();
  }
}

class _GenerateAvatarPageState<T>
    extends MobileBasePageState<GenerateAvatarPage> {
  List<String> types = [
    "male",
    "adventurer",
    "adventurer-neutral",
    "big-ears",
    "big-ears-neutral",
    "big-smile",
    "croodles",
    "croodles-neutral",
    "miniavs",
    "open-peeps",
    "personas",
    "pixel-art",
    "pixel-art-neutral",
    "female",
    "human",
    "identicon",
    "initials",
    "bottts",
    "avataaars",
    "jdenticon",
    "gridy",
    "micah"
  ];

  List<String> supportedImgTypes = ['svg', 'png'];

  String selectedImgType = 'png';

  List<String> moods = ["happy", "sad", "null"];

  bool isLoading = false;

  String defaultType = "avataaars";

  String currentMood = "";

  final TextEditingController _controller = TextEditingController();

  Color defaultBackgroundColor = Colors.white;

  DioUtils dioUtils = DioUtils();

  var remoteImageUrl = "";

  String svgData = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  baseBuild(BuildContext context) {
    return TaichiOverlay.simple(
      isLoading: isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(FlutterI18n.translate(
                      context, "avatarPage.chooseImgType")),
                  FindDropdown(
                    items: supportedImgTypes,
                    selectedItem: selectedImgType,
                    onChanged: (item) {
                      setState(() {
                        selectedImgType = item as String;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(FlutterI18n.translate(
                      context, "avatarPage.chooseAvatarType")),
                  FindDropdown(
                    items: types,
                    selectedItem: defaultType,
                    onChanged: (item) {
                      setState(() {
                        defaultType = item as String;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text("input a keyword"),
                  ComboWidget(
                    size: 150,
                    w1: Text(FlutterI18n.translate(
                        context, "avatarPage.inputKeyword")),
                    w2: Image.asset(
                      "assets/icons/quiz.png",
                      width: 20,
                      height: 20,
                    ),
                    tapOnW2: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              content: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    FlutterI18n.translate(
                                        context, "avatarPage.warning1"),
                                    maxLines: 5,
                                  )),
                              actions: [
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Got it"))
                              ],
                            );
                          });
                    },
                  ),

                  SizedBox(
                    height: 50,
                    width: 150,
                    child: TextField(
                      maxLength: 15,
                      controller: _controller,
                      decoration: InputDecoration(
                          counterText: "",
                          labelText: FlutterI18n.translate(
                              context, "avatarPage.keyword"),
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 205, 169, 181),
                            fontSize: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pink,
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text("background color"),
                  ComboWidget(
                    size: 150,
                    w1: Text(
                        FlutterI18n.translate(context, "avatarPage.bgColor")),
                    w2: Image.asset(
                      "assets/icons/quiz.png",
                      width: 20,
                      height: 20,
                    ),
                    tapOnW2: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              content: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    FlutterI18n.translate(
                                        context, "avatarPage.warning2"),
                                    maxLines: 10,
                                  )),
                              actions: [
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Got it"))
                              ],
                            );
                          });
                    },
                  ),
                  InkWell(
                    child: Container(
                      // color: defaultBackgroundColor,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: defaultBackgroundColor),
                      height: 40,
                      width: 80,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            FlutterI18n.translate(context, "avatarPage.select"),
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () async {
                          Color? selectedColor = await showDialog(
                              context: context,
                              builder: (context) {
                                return ColorPickerWidget(
                                  currentColor: defaultBackgroundColor,
                                );
                              });
                          if (null != selectedColor) {
                            setState(() {
                              debugPrint(selectedColor.value.toRadixString(16));
                              defaultBackgroundColor = selectedColor;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ComboWidget(
                    size: 150,
                    w1: Text(FlutterI18n.translate(
                        context, "avatarPage.chooseMood")),
                    w2: Image.asset(
                      "assets/icons/quiz.png",
                      width: 20,
                      height: 20,
                    ),
                    tapOnW2: () {
                      showToastMessage(
                          FlutterI18n.translate(context, "avatarPage.warning4"),
                          context);
                    },
                  ),
                  FindDropdown(
                    items: moods,
                    selectedItem: currentMood,
                    onChanged: (item) {
                      setState(() {
                        if (item as String == "null") {
                          currentMood = "";
                          return;
                        }
                        currentMood = item;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (remoteImageUrl != "")
              //   SvgPicture.asset("assets/_test_svg.svg"),
              Container(
                height: 300,
                width: 300,
                color: defaultBackgroundColor,
                child: ExtendedImage.network(remoteImageUrl),
              ),
            if (svgData != "")
              SizedBox(
                height: 300,
                width: 300,
                child: SvgPicture.string(svgData),
              ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_controller.text == "") {
                    showToastMessage(
                        FlutterI18n.translate(context, "avatarPage.warning3"),
                        context);
                  } else {
                    String url = quertStr +
                        defaultType +
                        "/" +
                        _controller.text +
                        ".$selectedImgType";

                    if (selectedImgType == "svg") {
                      url += "?background=%23" +
                          defaultBackgroundColor.value.toRadixString(16);
                    }

                    // String url = quertStr +
                    //     defaultType +
                    //     "/" +
                    //     _controller.text +
                    //     ".svg?";

                    if (currentMood != "") {
                      if (url.endsWith("?")) {
                        url += "&mood[]=$currentMood";
                      } else {
                        url += "?mood[]=$currentMood";
                      }
                    }

                    debugPrint("[debug svg-url] : $url");

                    setState(() {
                      isLoading = true;
                      svgData = "";
                      remoteImageUrl = "";
                    });

                    Response? result = await dioUtils.get(url);

                    // print(result.runtimeType);
                    setState(() {
                      if (result != null) {
                        if (selectedImgType == "png") {
                          remoteImageUrl = url;
                        } else {
                          svgData =
                              svgConvert(result.data).replaceAll("&lt;", "<");

                          // debugPrint("[svg-data] : $svgData");
                        }
                      }

                      isLoading = false;
                    });
                  }
                },
                child: Text(
                    FlutterI18n.translate(context, "avatarPage.generate"))),
            if (remoteImageUrl != "" || svgData != "")
              ElevatedButton(
                  onPressed: () {
                    context.read<AvatarController>().changeImg(
                        selectedImgType == "png"
                            ? AvatarType.png
                            : AvatarType.svg,
                        remoteImageUrl,
                        svgData,
                        defaultBackgroundColor);
                  },
                  child:
                      Text(FlutterI18n.translate(context, "avatarPage.submit")))
          ],
        ),
      ),
    );
  }
}
