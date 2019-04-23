import 'package:flutter/material.dart';
import 'container/index.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'redux/index.dart';
import 'apiRequest/index.dart';
import 'utils/sharedPreferences.dart';
import 'pages/account/login/index.dart';

void main() async {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  await initSharedPreferences();
  final store = await stateInit();
  dioConfig(store, navigatorKey); // dio请求配置
  runApp(new MyApp(store: store, navigatorKey: navigatorKey)); // 传入store
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
        home: FutureStore(),
        navigatorKey: widget.navigatorKey,
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => Login(),
        },
      )
    );
  }
}
