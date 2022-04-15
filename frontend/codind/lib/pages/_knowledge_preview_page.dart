import 'package:codind/entity/knowledge_entity.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

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
        child: Column(
          children: [
            Center(),
            Center(),
            Center(
              child: Text(
                "by 测试用户",
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
