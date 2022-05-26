// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:codind/utils/extensions/datetime_extension.dart';
import 'package:codind/widgets/create_event_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taichi/taichi.dart';

import '../providers/language_provider.dart';

// ignore: must_be_immutable
class ExpandedColumnWidget extends StatefulWidget {
  ExpandedColumnWidget({Key? key, required this.name}) : super(key: key);
  String name;

  @override
  State<ExpandedColumnWidget> createState() => ExpandedColumnWidgetState();
}

class ExpandedColumnWidgetState extends State<ExpandedColumnWidget> {
  List<Widget> children = [];
  List memories = [];

  // ignore: library_private_types_in_public_api
  List<Detais> getMemories() {
    List<Detais> details = [];
    if (children.length > 1) {
      for (int i = 0; i < children.length; i++) {
        if (children[i].runtimeType == DeletableWidget) {
          var _c =
              ((children[i] as DeletableWidget).child as DetailedWidget).detais;
          details.add(_c);
        } else {
          debugPrint("[runtime type]: ${children[i].runtimeType}");
        }
      }
    }
    return details;
  }

  void setMemories(List<Detais>? details) {
    if (details != null && details.isNotEmpty) {
      if (children.length > 1) {
        children.removeRange(0, children.length - 1);
      }

      for (var i in details) {
        addWidget(DetailedWidget(
          detais: i,
        ));
      }

      setState(() {});
    }
  }

  void addWidget(Widget? w) {
    int index = children.length;

    debugPrint("[add widget runtime type ]: ${w.runtimeType}");

    if (w != null) {
      children.insert(
          index - 1,
          DeletableWidget(
            index: index - 1,
            removeSelf: (v) => removeWidget(index - 1),
            child: w,
          ));
    } else {
      children.insert(
          index - 1,
          DeletableWidget(
            index: index - 1,
            removeSelf: (v) => removeWidget(index - 1),
            child: Container(
              height: 150,
              color: const Color.fromARGB(255, 241, 235, 221),
              // margin: const EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
            ),
          ));
    }

    setState(() {});

    debugPrint("[expanded_column_widget children.length] : ${children.length}");
  }

  void removeWidget(int index) {
    debugPrint("[expanded_column_widget remove index] : $index");

    // children.removeAt(index);
    Widget w = children.firstWhere((element) {
      if (element.runtimeType == DeletableWidget) {
        return (element as DeletableWidget).index == index;
      } else {
        return false;
      }
    }, orElse: () => Container());

    if (w.runtimeType != Container) {
      // var _index = children.indexOf(w);

      // context.read<ExperienceController>().removeValue(widget.name, _index);

      setState(() {
        children.remove(w);
      });

      // debugPrint(
      //     "[ExperienceController data] : ${context.read<ExperienceController>().edu}");
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("[ExpandedColumnWidget]: here init state");
    children.add(Container(
      height: 100,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      // width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.transparent,
        child: IconButton(
          icon: const Icon(
            Icons.add,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () async {
            var career = "";
            DateTime? startTime = DateTime.now();
            DateTime? endTime = DateTime.now().add(const Duration(days: 1));
            var sep =
                context.read<LanguageControllerV2>().currentLang == "zh_CN"
                    ? DatetimeSeparator.chinese
                    : DatetimeSeparator.slash;
            var res = await showCupertinoDialog(
                context: context,
                builder: (context) {
                  if (TaichiDevUtils.isMobile) {
                    return SafeArea(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Dialog(
                        insetPadding: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    color: Color(0xFFF7F7F7))
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "请输入",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("选择开始时间"),
                                  TextButton(
                                      onPressed: () async {
                                        showDatePicker(
                                                locale: context
                                                            .read<
                                                                LanguageControllerV2>()
                                                            .currentLang ==
                                                        "zh_CN"
                                                    ? const Locale("zh", "CH")
                                                    : const Locale("en", "US"),
                                                context: context,
                                                initialDate: startTime!,
                                                firstDate: DateTime(1970),
                                                lastDate: DateTime(
                                                    startTime!.year + 20))
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              startTime = value;
                                            });
                                          }
                                        });
                                      },
                                      child: Text(startTime!.toDateString(sep)))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("选择结束时间"),
                                  TextButton(
                                      onPressed: () async {
                                        showDatePicker(
                                                locale: context
                                                            .read<
                                                                LanguageControllerV2>()
                                                            .currentLang ==
                                                        "zh_CN"
                                                    ? const Locale("zh", "CH")
                                                    : const Locale("en", "US"),
                                                context: context,
                                                initialDate: startTime!,
                                                firstDate: DateTime(1970),
                                                lastDate: DateTime(
                                                    endTime!.year + 20))
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              endTime = value;
                                            });
                                          }
                                        });
                                      },
                                      child: Text(endTime!.toDateString(sep)))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(minHeight: 100),
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: TextField(
                                  maxLength: 200,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 39, 50, 100),
                                            width: 3)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.amber, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 3)),
                                  ),
                                  onChanged: (v) {
                                    career = v;
                                  },
                                ),
                              ),
                              Expanded(child: Container()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(0);
                                      },
                                      child: const Text("取消")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(1);
                                      },
                                      child: const Text("确定")),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
                  } else {
                    return UnconstrainedBox(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      color: Color(0xFFF7F7F7))
                                ],
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "请输入",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("选择开始时间"),
                                    TextButton(
                                        onPressed: () async {
                                          showDatePicker(
                                                  locale: context
                                                              .read<
                                                                  LanguageControllerV2>()
                                                              .currentLang ==
                                                          "zh_CN"
                                                      ? const Locale("zh", "CH")
                                                      : const Locale(
                                                          "en", "US"),
                                                  context: context,
                                                  initialDate: startTime!,
                                                  firstDate: DateTime(1970),
                                                  lastDate: DateTime(
                                                      startTime!.year + 20))
                                              .then((value) {
                                            if (value != null) {
                                              setState(() {
                                                startTime = value;
                                              });
                                            }
                                          });
                                        },
                                        child:
                                            Text(startTime!.toDateString(sep)))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("选择结束时间"),
                                    TextButton(
                                        onPressed: () async {
                                          showDatePicker(
                                                  locale: context
                                                              .read<
                                                                  LanguageControllerV2>()
                                                              .currentLang ==
                                                          "zh_CN"
                                                      ? const Locale("zh", "CH")
                                                      : const Locale(
                                                          "en", "US"),
                                                  context: context,
                                                  initialDate: startTime!,
                                                  firstDate: DateTime(1970),
                                                  lastDate: DateTime(
                                                      endTime!.year + 20))
                                              .then((value) {
                                            if (value != null) {
                                              setState(() {
                                                endTime = value;
                                              });
                                            }
                                          });
                                        },
                                        child: Text(endTime!.toDateString(sep)))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 100),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextField(
                                    maxLength: 200,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 39, 50, 100),
                                              width: 3)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.amber, width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green, width: 3)),
                                    ),
                                    onChanged: (v) {
                                      career = v;
                                    },
                                  ),
                                ),
                                Expanded(child: Container()),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(0);
                                        },
                                        child: const Text("取消")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(1);
                                        },
                                        child: const Text("确定")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                });

            if (res == 1) {
              debugPrint("[debug-starttime]:$startTime");
              debugPrint("[debug-endtime]:$endTime");
              addWidget(DetailedWidget(
                detais: Detais(
                  career: career,
                  start: startTime!.toDateString(sep),
                  end: endTime!.toDateString(sep),
                ),
              ));
            }
          },
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: children,
      ),
    );
  }
}

class Detais {
  String? start;
  String? end;
  String? career;

  Detais.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    career = json['career'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    data['career'] = career;
    return data;
  }

  Detais({required this.career, required this.end, required this.start});

  @override
  String toString() {
    return "$start~$end   $career";
  }
}

class DetailedWidget extends StatelessWidget {
  // ignore: library_private_types_in_public_api
  const DetailedWidget({Key? key, required this.detais}) : super(key: key);
  // ignore: library_private_types_in_public_api
  final Detais detais;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${detais.start}~${detais.end}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(detais.career ?? ""),
      ],
    );
  }
}

// ignore: must_be_immutable
class DeletableWidget extends StatelessWidget {
  DeletableWidget(
      {Key? key,
      required this.child,
      required this.index,
      required this.removeSelf,
      this.textWidgetKey})
      : super(key: key);
  Widget child;
  int index;
  GlobalKey? textWidgetKey;
  // ignore: prefer_typing_uninitialized_variables
  final removeSelf;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Expanded(child: child),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFF0000), width: 0.5),
              color: Colors.white,
              borderRadius: BorderRadius.circular((10.0))),
          child: IconButton(
            iconSize: 24,
            icon: const Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () {
              removeSelf(index);
            },
          ),
        )
      ]),
    );
  }
}

@Deprecated("will be removed")
// ignore: must_be_immutable
class TextWidgetV2 extends StatefulWidget {
  TextWidgetV2({Key? key, required this.name, required this.index})
      : super(key: key);
  String name;
  int index;

  @override
  State<TextWidgetV2> createState() => _TextWidgetV2State();
}

// ignore: deprecated_member_use_from_same_package
class _TextWidgetV2State extends State<TextWidgetV2> {
  String result = "";
  bool enable = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.grey[100],
      child: CreateEventWidget(
        name: widget.name,
        index: widget.index,
      ),
    );
  }
}
