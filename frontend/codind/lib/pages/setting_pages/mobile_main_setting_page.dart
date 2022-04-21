import 'package:codind/pages/setting_pages/account_safety_page.dart';
import 'package:codind/providers/my_providers.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart' show CustomListTile;
import '../_mobile_base_page.dart';
import '_custom_mainpage_cards_page.dart';

class MobileMainSettingPage extends MobileBasePage {
  MobileMainSettingPage({Key? key, required String pageName})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _MobileMainSettingPageState();
  }
}

class _MobileMainSettingPageState<T>
    extends MobileBasePageState<MobileMainSettingPage> {
  final TextStyle _style =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  final langList = ["zh_CN", "en"];

  @override
  baseBuild(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          CustomListTile(
            nextPage: AccountSafetyPage(),
            style: _style,
            title: "账号与安全",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // if (PlatformUtils.isMobile)
          //   CustomListTile(
          //     style: _style,
          //     title: "扫码登录桌面端",
          //     trailing: const Icon(
          //       Icons.chevron_right,
          //       size: 25,
          //     ),
          //   ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            style: _style,
            title: "隐私政策",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          CustomListTile(
            style: _style,
            title: "服务协议",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            style: _style,
            title: "选择语言",
            onTap: () async {
              var res = await showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return ChooseLangDialog();
                  });
              var _lang = langList[res];
              context.read<LanguageControllerV2>().changeLanguage(_lang);
            },
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            nextPage: CustomMainpageCardsPage(),
            style: _style,
            title: "管理首页内容",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              PersistenceStorage ps = PersistenceStorage();
              await ps.setUserEmail("");
              await ps.setUserPassword("");
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routers.pageLogin, (route) => false);
            },
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
    );
  }
}

class ChooseLangDialog extends StatefulWidget {
  ChooseLangDialog({Key? key}) : super(key: key);

  @override
  State<ChooseLangDialog> createState() => _ChooseLangDialogState();
}

class _ChooseLangDialogState extends State<ChooseLangDialog> {
  int lang = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("选择语言"),
      content: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                    value: 0,
                    groupValue: lang,
                    onChanged: (v) {
                      setState(() {
                        lang = v as int;
                      });
                      // print(lang);
                    }),
                const Text("中文")
              ],
            ),
            Row(
              children: [
                Radio(
                    value: 1,
                    groupValue: lang,
                    onChanged: (v) {
                      setState(() {
                        lang = v as int;
                      });
                      // print(lang);
                    }),
                const Text("English")
              ],
            ),
          ],
        ),
      ),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(lang);
            },
            child: const Text("OK"))
      ],
    );
  }
}
