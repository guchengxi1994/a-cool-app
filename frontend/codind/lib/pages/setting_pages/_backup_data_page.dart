import 'dart:convert';
import 'dart:io';

import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:taichi/taichi.dart';

import '../../_styles.dart';
import '../../widgets/custom_listtile.dart';

// ignore: must_be_immutable
class BackupDataPage extends MobileBasePage {
  BackupDataPage({Key? key}) : super(key: key, pageName: null);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _BackupDataPageState();
  }
}

class _BackupDataPageState extends MobileBasePageState<BackupDataPage> {
  bool isLoading = false;
  int pid = -1;
  @override
  Widget baseBuild(BuildContext context) {
    return TaichiOverlay.simple(
      isLoading: isLoading,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.baseAppbarColor,
            elevation: 0,
            title: const Text(
              "备份数据",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  if (pid == -1) {
                    Navigator.of(context).pop();
                  } else {
                    showToastMessage("服务器未关闭，无法退出");
                  }
                },
                icon: const Icon(
                  Icons.chevron_left,
                  size: AppTheme.leftBackIconSize,
                  color: Color.fromARGB(255, 78, 63, 63),
                )),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomListTile(
                  style: AppTheme.settingPageListTileTitleStyle,
                  onTap: () async {
                    var dir = Directory.current;
                    var p = "${dir.parent.parent.path}/backend/app.py";
                    debugPrint("[debug path]:$p");
                    bool b = File(p).existsSync();
                    debugPrint("[debug path exists]:$b");

                    if (b) {
                      var process = await Process.start('python', [p]);
                      debugPrint("process.pid:${process.pid}");
                      pid = process.pid;
                      process.stdout
                          .transform(utf8.decoder)
                          .forEach(debugPrint);
                      showToastMessage("开始成功");
                    } else {
                      showToastMessage("未找到文件");
                    }
                  },
                  title: "开启服务器",
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 25,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomListTile(
                  style: AppTheme.settingPageListTileTitleStyle,
                  onTap: () async {
                    if (pid != -1) {
                      Process.killPid(pid);
                      showToastMessage("已关闭");
                      pid = -1;
                      return;
                    }
                  },
                  title: "关闭服务器",
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 25,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
