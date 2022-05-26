import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../_styles.dart';
import '../../widgets/custom_listtile.dart';
import '../base_pages/_base_stateless_page.dart';
import 'markdown_pages/markdown_file_summary_page.dart';
import 'markdown_pages/markdown_writing_page.dart';

// ignore: must_be_immutable
class MarkdownMainPage extends BaseStatelessPage {
  MarkdownMainPage({Key? key}) : super(key: key, pageName: "创作工作台");

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomListTile(
            nextPage: MarkdownFileSummaryPage(),
            style: AppTheme.settingPageListTileTitleStyle,
            title: "查看所有文件",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            nextPage: WritingPage(
              routeName: FlutterI18n.translate(context, "label.md"),
              needLoading: true,
            ),
            style: AppTheme.settingPageListTileTitleStyle,
            title: "创作新的Markdown",
            trailing: const Icon(
              Icons.chevron_right,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
