import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../_styles.dart';
import '../../../entity/file_entity.dart';
import '../../../providers/files_provider.dart';
import '../../base_pages/_base_stateless_page.dart';
import 'markdown_reading_page.dart';

// ignore: must_be_immutable
class MarkdownFileSummaryPage extends BaseStatelessPage {
  MarkdownFileSummaryPage({Key? key}) : super(key: key, pageName: "文件汇总页面");

  @override
  Widget baseBuild(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int count = screenWidth ~/ 250;

    return ChangeNotifierProvider(
      create: (_) => MdFilesProvider()..init(),
      builder: (context, _) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: WaterfallFlow.builder(
                itemCount: context.watch<MdFilesProvider>().fileList.length,
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemBuilder: (context, index) {
                  FileLoggedToDbEntity e =
                      context.watch<MdFilesProvider>().fileList[index];

                  return MdFileSummaryWidget(
                    fileInfo: e,
                  );
                }),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class MdFileSummaryWidget extends StatelessWidget {
  MdFileSummaryWidget({Key? key, required this.fileInfo}) : super(key: key);
  FileLoggedToDbEntity fileInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MarkdownReadingPage(
              filepath: fileInfo.savedLocation,
            );
          }));
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileInfo.filename,
                maxLines: null,
                style: AppTheme.title,
              ),
              Text(
                fileInfo.savedTime.split(".")[0],
                style: AppTheme.subtitle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
