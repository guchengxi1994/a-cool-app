import 'package:codind/_apis.dart';
import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/utils/dio_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scan/scan.dart';
import 'package:taichi/taichi.dart';

import '../../router.dart';
import '../../utils/shared_preference_utils.dart';

class ScanMainPage {
  int? type;
  ScanMainPage({this.type = 0});

  Widget getPage() {
    if (type == 0) {
      return const ScanPage();
    } else {
      return MobileScanToLoginWidget();
    }
  }
}

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanController controller = ScanController();
  String qrcode = 'unknow';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 173, 139, 115),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop("");
          },
        ),
        centerTitle: true,
        title: Text(FlutterI18n.translate(context, "label.qrcodescan"),
            style: const TextStyle(
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.width * 0.95,
                width: MediaQuery.of(context).size.width * 0.95,
                child: ScanView(
                  controller: controller,
                  scanAreaScale: 0.8,
                  scanLineColor: const Color.fromARGB(255, 51, 34, 207),
                  onCapture: (data) {
                    debugPrint("[qr-result : $data]");
                    qrcode = data;
                  },
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(FlutterI18n.translate(
                            context, "button.label.quit"))),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                        onPressed: () {
                          controller.resume();
                        },
                        child: Text(FlutterI18n.translate(
                            context, "button.label.retry"))),
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).pop(datas);
                    },
                    child: Text(
                        FlutterI18n.translate(context, "button.label.ok"))),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// ignore: must_be_immutable
class MobileScanToLoginWidget extends MobileBasePage {
  MobileScanToLoginWidget({Key? key}) : super(key: key, pageName: "");

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _MobileScanToLoginWidgetState();
  }
}

class _MobileScanToLoginWidgetState
    extends MobileBasePageState<MobileScanToLoginWidget> {
  ScanController controller = ScanController();

  String qrCode = "";
  final DioUtils _dioUtils = DioUtils();
  final PersistenceStorage ps = PersistenceStorage();
  bool isLoading = false;

  @override
  baseBuild(BuildContext context) {
    return TaichiOverlay.simple(
        isLoading: isLoading,
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                height: 300,
                width: 300,
                child: ScanView(
                  controller: controller,
                  scanAreaScale: 0.8,
                  scanLineColor: const Color.fromARGB(255, 51, 34, 207),
                  onCapture: (data) {
                    debugPrint("[qr-result : $data]");
                    // qrcode = data;

                    setState(() {
                      qrCode = data;
                    });
                  },
                ),
              ),
              if (qrCode != "")
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      String email = await ps.getUserEmail();
                      String url =
                          apiRoute + Apis["login"]! + "k=$qrCode" + "&v=$email";

                      Response? response = await _dioUtils.get(url);
                      setState(() {
                        isLoading = false;
                      });

                      if (response != null && response.data != null) {
                        debugPrint(response.data);
                        if (Global.navigatorKey.currentState != null) {
                          Global.navigatorKey.currentState!
                              .pushNamedAndRemoveUntil(
                                  Routers.pageMain, (route) => false);
                        }
                      }
                    },
                    child: const Text("登录")),
            ],
          ),
        )));
  }
}
