import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// this is for mobile
/// test on web first

class MainPageV2 extends StatefulWidget {
  MainPageV2({Key? key}) : super(key: key);

  @override
  State<MainPageV2> createState() => _MainPageV2State();
}

class _MainPageV2State extends State<MainPageV2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [buildSliverGrid()];
        },
        body: buildBodyCards());
  }

  Widget buildBodyCards() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(20),
            child: Container(
              color: Colors.red,
              height: 80,
              child: Text(index.toString()),
            ),
          );
        });
  }

  Widget buildSliverGrid() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: null,
      title: null,
      expandedHeight: 230,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: const [
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: Text("0"),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: Text("1"),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Text("2"),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Text("3"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
