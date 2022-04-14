/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-13 18:48:03
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-14 22:15:20
 */
import 'package:codind/pages/_mobile_base_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/my_providers.dart';
import '_create_single_knowledge_page.dart';

class CreateKnowledgeBasePage extends MobileBasePage {
  CreateKnowledgeBasePage({Key? key, required pageName})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _CreateKnowledgePageState();
  }
}

class _CreateKnowledgePageState<T>
    extends MobileBasePageState<CreateKnowledgeBasePage> {
  @override
  baseBuild(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: context.watch<KnowledgeWidgetController>().items,
      ),
      bottomSheet: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CreateKnowledgeWidget();
                }));
              },
              icon: Icon(Icons.add))
        ],
      ),
    );
  }
}
