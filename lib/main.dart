import 'package:flutter/material.dart';
import 'container/index.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'redux/index.dart';
import 'apiRequest/index.dart';

void main() async {
  final store = await stateInit();
  dioConfig(store); // dio请求配置
  runApp(new MyApp(store: store));//传入store
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final Store store;
  MyApp({this.store});
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
        home: FutureStore()
      )
    );
  }
}
