import 'package:codind/pages/setting_pages/generate_avatar_page.dart';
import 'package:codind/providers/avatar_provider.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
import '../_background_color_mixin.dart';
import 'package:provider/provider.dart';

class AccountSafetyPage extends StatefulWidget {
  AccountSafetyPage({Key? key}) : super(key: key);

  @override
  State<AccountSafetyPage> createState() => _AccountSafetyPageState();
}

class _AccountSafetyPageState extends State<AccountSafetyPage>
    with BackgroundColorMixin {
  @override
  baseBackgroundBuild(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/title.png"))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GenerateAvatarPage();
                      }));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: buildAvatar(
                              context.watch<AvatarController>().img),
                        ),
                        Positioned(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              color: Colors.white,
                              child:
                                  const Icon(Icons.photo, color: Colors.blue),
                            ),
                          ),
                          right: 0,
                          bottom: 0,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("用户名",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Positioned(
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: leftBackIconSize,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              left: 5,
              top: 5,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          // Text("账户与安全"),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text("账户与安全"),
          ),
          // Container(
          //   color: Colors.white,
          //   child: ListTile(
          //     title: Text(
          //       "用户ID",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     trailing: Text("这里写ID"),
          //   ),
          // ),

          CustomListTile(
            style: const TextStyle(fontWeight: FontWeight.bold),
            title: "用户ID",
            trailing: Text("这里写ID"),
          ),

          // Container(
          //   color: Colors.white,
          //   child: ListTile(
          //     title: Text(
          //       "账户",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     trailing: Text("这里是email"),
          //   ),
          // ),

          CustomListTile(
            style: const TextStyle(fontWeight: FontWeight.bold),
            title: "账户",
            trailing: Text("这里是email"),
          ),

          const SizedBox(
            height: 20,
          ),
          InkWell(
            child: Container(
                height: 50,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "永久注销账号",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )),
          ),
        ],
      )),
    ));
  }
}
