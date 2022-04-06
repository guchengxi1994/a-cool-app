import 'package:codind/pages/setting_pages/account_safety_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../_background_color_mixin.dart';

class MobileMainSettingPage extends StatefulWidget {
  MobileMainSettingPage({Key? key}) : super(key: key);

  @override
  State<MobileMainSettingPage> createState() => _MobileMainSettingPageState();
}

class _MobileMainSettingPageState extends State<MobileMainSettingPage>
    with BackgroundColorMixin {
  final TextStyle _style =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  @override
  baseBackgroundBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          FlutterI18n.translate(context, "label.settings"),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 35,
              color: Color.fromARGB(255, 78, 63, 63),
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: ListTile(
                onTap: () {
                  // Navigator.of(context).pushNamed(Routers.pageAccountSafty);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AccountSafetyPage();
                  }));
                },
                title: Text(
                  "账号与安全",
                  style: _style,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  "隐私政策",
                  style: _style,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 25,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  "服务协议",
                  style: _style,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "退出登录",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
