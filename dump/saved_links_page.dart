import 'package:codind/entity/entity.dart';
import 'package:codind/utils/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/my_blocs.dart';

class SavedLinksPage extends StatefulWidget {
  SavedLinksPage({Key? key}) : super(key: key);

  @override
  State<SavedLinksPage> createState() => _SavedLinksPageState();
}

class _SavedLinksPageState extends State<SavedLinksPage> {
  late SavedLinksBloc _savedLinksBloc;
  List<Widget> _widgets = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _savedLinksBloc = context.read<SavedLinksBloc>();
    _widgets.addAll([
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
      getLinkWidget(Link()),
    ]);

    _scrollController.addListener(() {
      //判断是否滑动到了页面的最底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //如果不是最后一页数据，则生成新的数据添加到list里面
        Future.delayed(Duration(seconds: 2)).then((e) {
          for (int i = 0; i < 5; i++) {
            _widgets.insert(_widgets.length, getLinkWidget(Link()));
          }
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedLinksBloc, SavedLinksState>(
        builder: (context, state) {
      return Scaffold(
        extendBody: false,
        appBar: AppBar(
          automaticallyImplyLeading: !PlatformUtils.isWeb,
          elevation: PlatformUtils.isMobile ? 4 : 0,
        ),
        body: !PlatformUtils.isMobile
            ? SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 60, top: 20),
                child: Wrap(alignment: WrapAlignment.start, children: [
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                  getLinkWidget(Link()),
                ]))
            : RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 60, top: 20),
                    itemCount: _widgets.length + 1,
                    itemBuilder: ((context, index) {
                      if (index == _widgets.length) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: _widgets[index],
                      );
                    })),
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 110));
                }),
        bottomSheet: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_box,
                  color: Colors.black,
                ))
          ],
        ),
      );
    });
  }
}

const double cardHeight = 300;
double cardWidth = 200;
Widget getLinkWidget(Link link) {
  if (PlatformUtils.isMobile) {
    cardWidth = 0.8 * CommonUtils.screenW();
  }

  return Card(
    // margin: const EdgeInsets.all(5),

    child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: cardHeight,
        width: cardWidth,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(5),
                      topEnd: Radius.circular(5))),
              clipBehavior: Clip.antiAlias,
              child: link.thumvnailUrl != null
                  ? ExtendedImage.network(
                      link.thumvnailUrl!,
                      // height: 0.5 * cardHeight,
                      height: PlatformUtils.isMobile
                          ? 0.7 * cardHeight
                          : 0.5 * cardHeight,
                      width: cardWidth,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    )
                  : ExtendedImage.asset(
                      "assets/images/kl.jpg",
                      fit: BoxFit.cover,
                      height: PlatformUtils.isMobile
                          ? 0.7 * cardHeight
                          : 0.5 * cardHeight,
                      width: cardWidth,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
            ),
          ],
        )),
  );
}
