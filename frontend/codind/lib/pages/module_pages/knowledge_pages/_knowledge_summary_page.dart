// ignore_for_file: must_be_immutable, prefer_const_constructors, depend_on_referenced_packages

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
import 'package:taichi/taichi.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../providers/my_providers.dart';
import '_create_single_knowledge_page.dart';

class KnowledgeSummaryPage extends MobileBasePage {
  KnowledgeSummaryPage({Key? key, required pageName})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _KnowledgeSummaryPageState();
  }
}

class _KnowledgeSummaryPageState<T>
    extends MobileBasePageState<KnowledgeSummaryPage> {
  // ignore: prefer_typing_uninitialized_variables
  var fetchAllKnowledge;

  getAll() async {
    await context.read<KnowledgeController>().fetchAll();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("[debug ]: start query database");
    fetchAllKnowledge = getAll();
  }

  @override
  baseBuild(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int count = screenWidth ~/ 250;

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: WaterfallFlow.builder(
                padding: EdgeInsets.all(20),
                itemCount: context.watch<KnowledgeController>().widgets.length,
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemBuilder: (context, index) {
                  return context.watch<KnowledgeController>().widgets[index];
                }),
            floatingActionButton: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreateKnowledgeWidget();
                      }));
                    },
                    child: Icon(
                      Icons.add,
                      size: 30,
                      semanticLabel: "Add",
                    ))),
          );
        } else {
          return TaichiAutoRotateGraph.simple(size: 150);
        }
      },
      future: fetchAllKnowledge,
    );
  }
}
