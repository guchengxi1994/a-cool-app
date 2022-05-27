// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() async {
  var process = await Process.start('ping', ['-t', 'www.baidu.com']);
  print(process.pid);
  process.stdout.transform(utf8.decoder).forEach(print);

  Future.delayed(const Duration(seconds: 5))
      .then((value) => Process.killPid(process.pid));
}
