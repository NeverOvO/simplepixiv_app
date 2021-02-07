import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:simplepixiv_app/Base/EventBus.dart';

import 'Base/routes.dart';

void main() {
  if(Platform.isAndroid){
    HttpOverrides.global = GlobalHttpOverrides();
  }
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  with WidgetsBindingObserver  {


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // _initFluwx();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
      // bus.emit('AppLifecycleState.paused','');
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //微信初始化
  // _initFluwx() async {
  //   await registerWxApi(
  //       appId: "XXXXXXXXX",
  //       doOnAndroid: true,
  //       doOnIOS: true,
  //       universalLink: "https://www.XXXX.com/api/weixin/");
  //   var result = await isWeChatInstalled;
  //   print("is installed $result");
  // }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixiv随机色图',
      // showPerformanceOverlay: true,
      navigatorKey: navigatorKey,
      initialRoute:  '/bottomBatItem',
      onGenerateRoute: onGenerateRoute,
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: BotToastInit(),
      theme: ThemeData(
        cardColor:Colors.white,//为了弹窗
        brightness: Brightness.light,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        canvasColor: Colors.white,//页面背景色
        backgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,//隐藏底部阴影分割线
          centerTitle: true,//标题是否居中 安卓上有效ios默认居中
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),
          ),
        ),
        buttonTheme: new ButtonThemeData(
          minWidth: 0,
          height: 0,
          padding: EdgeInsets.all(0),
          buttonColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white,fontSize: 14),
        ),
      ),
    );
  }
}

//全域忽略SSL
class GlobalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}