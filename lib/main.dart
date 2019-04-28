import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //提供SystemUiOverlayStyle
import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'redux/index.dart';
import 'apiRequest/index.dart';
import 'utils/sharedPreferences.dart';
import 'authenticationRoute.dart';

void main() async {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  await initSharedPreferences();
  final store = await stateInit();
  dioConfig(store, navigatorKey); // dio请求配置
  runApp(new MyApp(store: store, navigatorKey: navigatorKey)); // 传入store
  if (Platform.isAndroid) {
   // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前       MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:    Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final Store store;
  final GlobalKey navigatorKey;
  MyApp({this.store, this.navigatorKey});
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<dynamic> (
      store: widget.store,
      child: MaterialApp(
        title: '未来商城',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: FutureStore(),
        navigatorKey: widget.navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          bool isLogin = widget.store.state.myInfo.infos['id'] != null;
          print(isLogin);
          return authenticationRoute(settings, isLogin);
        }
      )
    );
  }
}
