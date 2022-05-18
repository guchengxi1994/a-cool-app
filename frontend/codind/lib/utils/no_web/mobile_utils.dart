import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> saveFile({required String filename, required String data}) async {
  var dir = await getApplicationSupportDirectory();

  File file = File("${dir.path}/$filename");
  await file.create();
  await file.writeAsString(
    data,
  );

  // ignore: avoid_print
  print("${dir.path}/$filename");
}
