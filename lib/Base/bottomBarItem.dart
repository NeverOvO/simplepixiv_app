import 'dart:convert';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:simplepixiv_app/Index/Controller/HomePageViewController.dart';
import 'package:flutter/material.dart';
import 'package:simplepixiv_app/Base/EventBus.dart';
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
    // KeywordSearchViewController(),
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.star),
            activeIcon: Icon(Icons.star),
            label: "随机抽卡!",//title: Text("消息",style: TextStyle(color: currentIndex == 0 ? Colors.white : Colors.grey),),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings),
            label: "全局设置!",//title: Text("我的",style: TextStyle(color: currentIndex == 4 ? Colors.white : Colors.grey),),
          ),
        ],
        currentIndex: currentIndex,
        backgroundColor: Color.fromRGBO(31, 146, 240, 0.8),
        type: BottomNavigationBarType.fixed,
        selectedFontSize :12.0,
        selectedItemColor: Colors.amber,
        unselectedFontSize : 12.0,
        unselectedItemColor: Colors.white,
        onTap: onTap,
      ),
    );
  }
}
