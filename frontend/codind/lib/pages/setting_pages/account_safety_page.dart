// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:codind/pages/setting_pages/generate_avatar_page.dart';
import 'package:codind/providers/userinfo_provider.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../_styles.dart';
import '../mixins/_background_color_mixin.dart';
import 'package:provider/provider.dart';

class AccountSafetyPage extends StatefulWidget {
  const AccountSafetyPage({Key? key}) : super(key: key);

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
                        return GenerateAvatarPage(
                          pageName: "头像生成工具",
                        );
                      }));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: buildAvatar(
                              context.watch<UserinfoController>().img),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              color: Colors.white,
                              child:
                                  const Icon(Icons.photo, color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      context.read<UserinfoController>().userData.userName ??
                          "未修改用户名",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Positioned(
              left: 5,
              top: 5,
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: AppTheme.leftBackIconSize,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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

          CustomListTile(
            style: const TextStyle(fontWeight: FontWeight.bold),
            title: "用户ID",
            trailing: Text(
                context.read<UserinfoController>().userData.userName ?? "未知"),
          ),

          CustomListTile(
            style: const TextStyle(fontWeight: FontWeight.bold),
            title: "账户",
            trailing: Text(
                context.read<UserinfoController>().userData.userEmail ?? "未知"),
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
