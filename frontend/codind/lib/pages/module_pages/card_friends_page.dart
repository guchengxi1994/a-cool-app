// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:card_swiper/card_swiper.dart';
import 'package:codind/utils/utils.dart';
import 'package:codind/widgets/card_widget.dart';
import 'package:flutter/material.dart';

import '../base_pages/_mobile_base_page.dart';

/// friend page
class CardPage extends MobileBasePage {
  CardPage({Key? key}) : super(key: key, pageName: "Friends");

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _CardPageState();
  }
}

class _CardPageState<T> extends MobileBasePageState<CardPage> {
  ScrollController scrollController = ScrollController();
  int currentIndex = 0;
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          SizedBox(
              height: 0.65 * CommonUtils.screenH(),
              child: Center(
                child: Swiper(
                  key: UniqueKey(),
                  itemBuilder: (BuildContext context, int index) {
                    return CardWidget(
                      index: index,
                    );
                  },
                  itemCount: 10,
                  index: currentIndex,
                  viewportFraction: 0.75,
                  scale: 0.8,
                  onIndexChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                    // currentIndex = index;
                    scrollController.animateTo(currentIndex * 80,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeOut);
                  },
                ),
              )),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 110,
            width: CommonUtils.screenW(),
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                      width: 20,
                    ),
                padding: EdgeInsets.only(left: 20, right: 20),
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // print(index);
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    child: Container(
                      decoration: currentIndex == index
                          ? BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))
                          : null,
                      child: CardListWidget(
                        index: index,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
