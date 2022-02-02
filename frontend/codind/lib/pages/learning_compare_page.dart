/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-01 10:33:14
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-02 18:03:15
 */

import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '_base_page.dart';
import '_base_preview_page.dart';

class LearningComparePage extends BasePage {
  LearningComparePage({Key? key, required this.left, this.right})
      : super(key: key);
  Widget left;
  BaseMarkdownPreviewPage? right;

  @override
  BasePageState<BasePage> getState() {
    return _LearningComparePageState();
  }
}

class _LearningComparePageState<T> extends BasePageState<LearningComparePage> {
  Color selectedColor = Colors.red;
  Color unSelectedColor = Colors.grey;

  bool isSelected = false;

  @override
  baseBuild(BuildContext context) {
    return buildView();
  }

  Widget buildView() {
    if (Responsive.isRoughMobile(context)) {
      return Scaffold(
        endDrawer: SizedBox(
          width: 0.8 * CommonUtils.screenW(),
          child: widget.right,
        ),
        body: widget.left,
        bottomSheet: SizedBox(
          height: 50,
          child: Container(
            width: CommonUtils.screenW(),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!, width: 0.5),
                color: Colors.grey[200]!,
                borderRadius: BorderRadius.circular((20.0))),
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                      );
                    });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(FlutterI18n.translate(context, "label.leaveYourCommit"))
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: widget.left,
              flex: 1,
            ),
            const VerticalDivider(
              thickness: 2,
              color: Colors.grey,
            ),
            Expanded(
              child: widget.right!,
              flex: 1,
            )
          ],
        ),
        bottomSheet: Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                icon: Icon(
                  Icons.thumb_up,
                  color: isSelected ? selectedColor : unSelectedColor,
                ))
          ],
        ),
      );
    }
  }
}
