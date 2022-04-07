import 'package:codind/pages/setting_pages/account_safety_page.dart';
import 'package:codind/providers/my_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../_mobile_base_page.dart';

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
          Container(
            color: Colors.white,
            child: ListTile(
              onTap: () async {
                var res = await showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return ChooseLangDialog();
                    });

                var _lang = langList[res];

                context.read<LanguageControllerV2>().changeLanguage(_lang);
              },
              title: Text(
                "选择语言",
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
