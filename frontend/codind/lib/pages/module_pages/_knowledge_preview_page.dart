// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:codind/entity/knowledge_entity.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class KnowlegetPreviewPage extends StatelessWidget {
  KnowlegetPreviewPage({Key? key, required this.data}) : super(key: key);
  KnowledgeEntity data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("预览"),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: leftBackIconSize,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
                child: Text(
              data.title ?? "",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Text(data.time ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: RichText(
                  maxLines: null,
                  text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                            text: "摘要: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: data.summary)
                      ])),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              data.detail ?? "",
              maxLines: null,
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                    TextSpan(
                      text: "by ",
                    ),
                    TextSpan(
                        text: "测试用户",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ))
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
