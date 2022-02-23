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

  @override
  void initState() {
    super.initState();
    _savedLinksBloc = context.read<SavedLinksBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedLinksBloc, SavedLinksState>(
        builder: (context, state) {
      return Scaffold(
        // extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: !PlatformUtils.isWeb,
          elevation: PlatformUtils.isMobile ? 4 : 0,
        ),
        body: SingleChildScrollView(
            child: !PlatformUtils.isMobile
                ? Wrap(alignment: WrapAlignment.start, children: [
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
                  ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                    ],
                  )),
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
const double cardWidth = 200;
Widget getLinkWidget(Link link) {
  return Card(
    margin: const EdgeInsets.all(5),
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
                      height: 0.5 * cardHeight,
                      width: cardWidth,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    )
                  : ExtendedImage.asset(
                      "assets/images/kl.jpg",
                      fit: BoxFit.cover,
                      height: 0.5 * cardHeight,
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
