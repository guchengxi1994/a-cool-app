import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class UserAvatarWidget extends StatelessWidget {
  UserAvatarWidget({Key? key, required this.imgUrl, required this.userInfo})
      : super(key: key);
  String? imgUrl;
  String? userInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: CircleAvatar(
              backgroundImage: imgUrl == null
                  ? const AssetImage("assets/images/bg.jpg")
                  : ExtendedNetworkImageProvider(imgUrl!) as ImageProvider,
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
      child: Center(
        child: Text(FlutterI18n.translate(context, "label.nothingtodo")),
      ),
    );
  }
}
