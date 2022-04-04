// ignore_for_file: prefer_const_constructors

import 'package:codind/entity/entity.dart';
import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

/// thanks to "dicebear" and
/// this uses https://avatars.dicebear.com/docs/http-api

const quertStr = "https://avatars.dicebear.com/api/";

class GenerateAvatarPage extends StatefulWidget {
  GenerateAvatarPage({Key? key}) : super(key: key);

  @override
  State<GenerateAvatarPage> createState() => _GenerateAvatarPageState();
}

class _GenerateAvatarPageState extends State<GenerateAvatarPage> {
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
  void initState() {
    super.initState();
    types.sort((a, b) => a[0].compareTo(b[0]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("choose an image type"),
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("choose a type"),
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text("input a keyword"),
                  ComboWidget(
                    size: 150,
                    w1: const Text("input a keyword"),
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
                                  child: Text(
                                "1. The keyword can be anything you like - but don't use any sensitive or personal data here. \n"
                                "2. Max length of the keyword is 15.",
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
                      decoration: const InputDecoration(
                          counterText: "",
                          labelText: 'keyword',
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text("background color"),
                  ComboWidget(
                    size: 150,
                    w1: Text("background color"),
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
                                  child: Text(
                                "开源的flutter_svg (1.0.3版本)库存在一些问题，所以本人会对svg的xml先进行一次解析，如果遇到显示问题请切换关键词重试。",
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
                            "Select",
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ComboWidget(
                    size: 150,
                    w1: Text("choose a mood"),
                    w2: Image.asset(
                      "assets/icons/quiz.png",
                      width: 20,
                      height: 20,
                    ),
                    tapOnW2: () {
                      showToastMessage("value can be blank", context);
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
                      showToastMessage("keyword cannot be blank", context);
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
                  child: Text("Generate")),
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
                    child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
