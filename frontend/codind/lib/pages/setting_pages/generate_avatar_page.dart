// ignore_for_file: prefer_const_constructors

import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

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
                  Text("background color"),
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
                Container(
                  color: defaultBackgroundColor,
                  child: ExtendedImage.network(remoteImageUrl),
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
                      });

                      Response? result = await dioUtils.get(url);

                      // print(result.runtimeType);
                      setState(() {
                        if (result != null) {
                          remoteImageUrl = url;
                        }

                        isLoading = false;
                      });
                    }
                  },
                  child: Text("Generate")),
            ],
          ),
        ),
      ),
    );
  }
}
