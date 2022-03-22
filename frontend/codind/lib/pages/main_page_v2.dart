/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-22 19:54:23
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-03-22 21:21:19
 */
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // color: Colors.white,
          height: 300,
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: UserAvatarWidget(
                  imgUrl: null,
                  userInfo: null,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: TodoListWidget(
                        todos: ["aaa", "bbb", "ccc"],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                        child: Row(
                      children: const [
                        Expanded(
                          flex: 1,
                          child: SignupButton(),
                        ),
                        Expanded(
                          flex: 1,
                          child: SettingButton(),
                        )
                      ],
                    )),
                  ],
                ),
              )
            ],
          ),
          // child: StaggeredGrid.count(
          //   crossAxisCount: 4,
          //   mainAxisSpacing: 4,
          //   crossAxisSpacing: 4,
          //   children: [
          //     StaggeredGridTile.count(
          //       crossAxisCellCount: 2,
          //       mainAxisCellCount: 2,
          // child: UserAvatarWidget(
          //   imgUrl: null,
          //   userInfo: null,
          // ),
          //     ),
          //     StaggeredGridTile.count(
          //       crossAxisCellCount: 2,
          //       mainAxisCellCount: 1,
          //       child: TodoListWidget(
          //         todos: ["aaa", "bbb", "ccc"],
          //       ),
          //     ),
          //     const StaggeredGridTile.count(
          //       crossAxisCellCount: 1,
          //       mainAxisCellCount: 1,
          //       child: SignupButton(),
          //     ),
          //     const StaggeredGridTile.count(
          //       crossAxisCellCount: 1,
          //       mainAxisCellCount: 1,
          //       child: SettingButton(),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
