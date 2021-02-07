
import 'package:simplepixiv_app/Index/Controller/HomePageViewController.dart';
import 'package:flutter/material.dart';
import 'package:simplepixiv_app/Base/bottomBarItem.dart';
import 'package:simplepixiv_app/Index/Controller/KeywordSearchViewController.dart';
import 'package:simplepixiv_app/Index/Controller/SettingViewController.dart';


final routes = {
  //底部栏
  '/bottomBatItem': (context, {arguments}) => bottomBatItem(arguments: arguments),
  //首页/最新
  '/HomePageViewController': (context, {arguments}) =>HomePageViewController(arguments: arguments),
  //设置
  '/SettingViewController' : (context, {arguments}) =>SettingViewController(arguments: arguments),
  //关键字搜索
  '/KeywordSearchViewController' : (context, {arguments}) =>KeywordSearchViewController(arguments: arguments),
};

// ignore: top_level_function_literal_block, missing_return
var onGenerateRoute = (RouteSettings settings){
  final String name = settings.name;

  final Function pageContentBuilder = routes[name];

  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments),
      );
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
