import 'package:card_swiper/card_swiper.dart';
import 'package:codind/entity/avatar_img_entity.dart';
import 'package:codind/providers/my_providers.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/main_page_widgets/main_page_expanded_widget.dart';
import 'package:codind/widgets/mobile_widgets/qr_scanner_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import '../../entity/entity.dart';
import 'radar_chart.dart';

class UserAvatarWidget extends StatelessWidget {
  UserAvatarWidget({
    Key? key,
    required this.avatarImg,
    required this.userInfo,
  }) : super(key: key);

  String? userInfo;
  AvatarImg? avatarImg;

  @override
  Widget build(BuildContext context) {
    // debugPrint("[debug avatarImg]: ${avatarImg.toString()}");

    return Card(
      color: const Color.fromARGB(255, 199, 177, 152),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Transform.rotate(
              angle: context.watch<AngleController>().angle,
              child: buildAvatar(avatarImg),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (userInfo != null)
            Text(
              userInfo ?? "用户A",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
        ],
      ),
    );
  }
}

Widget buildAvatar(AvatarImg? avatarImg) {
  if (avatarImg == null || avatarImg.type == AvatarType.undefined) {
    return const CircleAvatar(
      backgroundImage: AssetImage("assets/images/bg.jpg"),
    );
  } else {
    if (avatarImg.type == AvatarType.png) {
      return CircleAvatar(
        backgroundColor: avatarImg.background,
        backgroundImage: ExtendedNetworkImageProvider(avatarImg.imgPath!),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SvgPicture.string(avatarImg.imgData!),
      );
    }
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(150, 199, 177, 152),
      child: InkWell(
        onTap: () {
          if (PlatformUtils.isMobile) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const ScanMainPage();
            }));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/icons/dk.png",
              width: 50,
              height: 50,
            ),
            Text(FlutterI18n.translate(context, "label.signin"))
          ],
        ),
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(150, 199, 177, 152),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Routers.pageMobileSettingsPage);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.settings,
              // size: MediaQuery.of(context).size.width * 0.1,
              color: Colors.black,
            ),
            Text(
              FlutterI18n.translate(context, "label.settings1"),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}

class TodoListWidget extends StatelessWidget {
  TodoListWidget({Key? key, required this.todos}) : super(key: key);
  List<String> todos;
  @override
  Widget build(BuildContext context) {
    if (todos.isNotEmpty) {
      return Card(
        color: const Color.fromARGB(200, 199, 177, 152),
        child: Swiper(
          autoplayDelay: 2000,
          viewportFraction: 0.8,
          scale: 0.9,
          loop: todos.length > 1,
          autoplay: todos.length > 1,
          itemCount: todos.length,
          scrollDirection: Axis.vertical,
          itemHeight: 50,
          itemWidth: 100,
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                todos[index],
                maxLines: 2,
              ),
            );
          },
        ),
      );
    }

    return Card(
      color: const Color.fromARGB(200, 199, 177, 152),
      child: Center(
        child: Text(FlutterI18n.translate(context, "label.nothingtodo")),
      ),
    );
  }
}

@Deprecated("shoulu not be used")
class SummaryCardDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height) {
      return SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ));
    }

    buildCollapsed2() {
      return InkWell(
        child: buildImg(Colors.lightGreenAccent, 150),
      );
    }

    buildExpanded2() {
      return const RadarAbilityChart();
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Builder(
            builder: (context) {
              var controller =
                  ExpandableController.of(context, required: true)!;
              return Expandable(
                collapsed: InkWell(
                  onTap: () {
                    controller.toggle();
                  },
                  child: buildCollapsed2(),
                ),
                expanded: Stack(children: [
                  buildExpanded2(),
                  Positioned(
                      right: 5,
                      top: 5,
                      child: IconButton(
                        onPressed: () {
                          controller.toggle();
                        },
                        icon: const Icon(Icons.close),
                      ))
                ]),
              );
            },
          ),
        ),
      ),
    ));
  }
}

class MainPageCard extends StatelessWidget {
  Widget collapsedWidget;
  Widget expanedWidget;
  Color? closeIconColor;
  Color? expandedMainColor;

  MainPageCard(
      {Key? key,
      required this.collapsedWidget,
      required this.expanedWidget,
      required this.closeIconColor,
      this.expandedMainColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(child: ScrollOnExpand(
      child: Builder(
        builder: (context) {
          var controller = ExpandableController.of(context, required: true)!;
          return Expandable(
            collapsed: InkWell(
              onTap: () {
                controller.toggle();
              },
              child: collapsedWidget,
            ),
            expanded: Stack(children: [
              CoolExpandedWidget(
                mainColor: expandedMainColor,
                child: expanedWidget,
              ),
              Positioned(
                  right: 35,
                  top: 15,
                  child: IconButton(
                    onPressed: () {
                      controller.toggle();
                    },
                    icon: Icon(
                      Icons.close,
                      size: 30,
                      color: closeIconColor ?? Colors.black,
                    ),
                  ))
            ]),
          );
        },
      ),
    ));
  }
}

@Deprecated("not beautiful as expected")
class MainPageCustomListTile extends StatelessWidget {
  MainPageCustomListTile({Key? key, required this.icon, required this.title})
      : super(key: key);
  static const double fontSize = 25.0;

  String title;
  Widget icon;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        height: 100,
        child: Card(
          color: const Color.fromARGB(255, 199, 177, 152),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // icon,
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: icon,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    // FlutterI18n.translate(context, "resume.title"),
                    title,
                    style: const TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
