import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';

class Store extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Store();
  }
}

class _Store extends State<Store> {
  List slideList = [];
  @override
  void initState() {
    super.initState();
    _getStoreHomeData();
  }

  _getStoreHomeData() async {
    var res = await getStoreHomeData();
    var dataList = json.decode(res['view']['data']);
    var slideData = dataList.where((item) => item['module'] == 'slide').toList();
    var productData = dataList.where((item) => item['module'] == 'product').toList();
    setState(() {
      slideList = slideData['data']['list']; // 轮播图数据
    });
    print(slideData);
    print(productData);
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, Map>(
      converter: (store) => store.state.language.data,//转换从redux拿回来的值
      builder: (context, language) {
        return Scaffold(
          body: Container(
            child: Text(language['how_to_deposit']),
          )
        );
      },
    );
  }
}