import 'dart:convert';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:simplepixiv_app/Index/Controller/HomePageViewController.dart';
import 'package:flutter/material.dart';
import 'package:simplepixiv_app/Base/EventBus.dart';
import 'package:simplepixiv_app/Index/Controller/KeywordSearchViewController.dart';
import 'package:simplepixiv_app/Index/Controller/SettingViewController.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';


class bottomBatItem extends StatefulWidget {
  final arguments;

  const bottomBatItem({Key key, this.arguments}) : super(key: key);
  @override
  _bottomBatItemState createState() => _bottomBatItemState();
}

class _bottomBatItemState extends State<bottomBatItem> {
  int currentIndex = 0;
  final pageController = PageController();
  @override
  void initState() {
    super.initState();
    bus.on("BottomBarToggle", (object) {
      setState(() {
        currentIndex = object;
        pageController.jumpToPage(currentIndex);
      });
    });
  }

  void onTap(int index) {
    pageController.jumpToPage(index);
    bus.emit('pageController', index);
    if(index ==0 || index == 1){
      bus.emit('updateDate');
    }
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  @override
  void deactivate() {
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      print('返回主页');
    }
  }

  @override
  void dispose() {
    super.dispose();
    bus.off("BottomBarToggle");
  }

  final pages = [
    HomePageViewController(),
    KeywordSearchViewController(),
    SettingViewController(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onTabChange: (int index) {
          currentIndex = index;
          onTap(index);
        },
        outerPadding:const EdgeInsets.fromLTRB(30, 0, 30, 0),
        fontSize:17,
        activeButtonFlexFactor : 90,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        navigationBarButtons: <NavigationBarButton>[
          NavigationBarButton(
            text: '随机抽卡!',
            icon: Icons.star,
            backgroundGradient: const LinearGradient(colors: <Color>[Colors.blue, Colors.lightBlue, Colors.yellow],),
          ),
          NavigationBarButton(
            text: '查找色图!',
            icon: Icons.search,
            backgroundGradient: const LinearGradient(colors: <Color>[Colors.red,Colors.redAccent, Colors.yellow],),
          ),
          NavigationBarButton(
            text: '全局设置',
            icon: Icons.settings,
            backgroundGradient: const LinearGradient(colors: <Color>[Colors.green,Colors.greenAccent, Colors.yellow],),
          ),
        ],
      ),
    );
  }
}
