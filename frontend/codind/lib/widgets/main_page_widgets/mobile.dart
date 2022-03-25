import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';

import '../../providers/avatar_angle_provider.dart';
import 'radar_chart.dart';

class UserAvatarWidget extends StatelessWidget {
  UserAvatarWidget({
    Key? key,
    required this.imgUrl,
    required this.userInfo,
  }) : super(key: key);
  String? imgUrl;
  String? userInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 199, 177, 152),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.rotate(
              angle: context.watch<AngleController>().angle,
              child: CircleAvatar(
                backgroundImage: imgUrl == null
                    ? const AssetImage("assets/images/bg.jpg")
                    : ExtendedNetworkImageProvider(imgUrl!) as ImageProvider,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(userInfo ?? "用户A")
        ],
      ),
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(150, 199, 177, 152),
      child: InkWell(
        onTap: () {},
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
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.settings,
              size: 50,
              color: Colors.black,
            ),
            Text(FlutterI18n.translate(context, "label.settings1"))
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
              child: Text(todos[index]),
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

  MainPageCard(
      {Key? key, required this.collapsedWidget, required this.expanedWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  child: collapsedWidget,
                ),
                expanded: Stack(children: [
                  expanedWidget,
                  Positioned(
                      right: 15,
                      top: 5,
                      child: IconButton(
                        onPressed: () {
                          controller.toggle();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 30,
                        ),
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
