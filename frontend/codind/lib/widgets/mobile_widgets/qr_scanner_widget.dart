import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scan/scan.dart';

class ScanMainPage extends StatelessWidget {
  const ScanMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScanPage();
  }
}

class ScanPage extends StatefulWidget {
  ScanPage({Key? key}) : super(key: key);

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
