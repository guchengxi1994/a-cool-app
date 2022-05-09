// ignore_for_file: must_be_immutable, prefer_const_constructors

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-13 18:48:03
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-14 22:15:20
 */
import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../providers/my_providers.dart';
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
      body: WaterfallFlow.builder(
          padding: EdgeInsets.all(20),
          itemCount: context.watch<KnowledgeWidgetController>().items.length,
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (context, index) {
            return context.watch<KnowledgeWidgetController>().items[index];
          }),
      floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 20, right: 20),
          child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CreateKnowledgeWidget();
                }));
              },
              child: Icon(
                Icons.add,
                size: 30,
                semanticLabel: "Add",
              ))),
    );
  }
}
