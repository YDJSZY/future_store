import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Store extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Store();
  }
}

class _Store extends State<Store> {
  @override
  void initState() {
    super.initState();
    print('商城');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new StoreConnector<dynamic, Map>(
        converter: (store) => store.state.language.data,//转换从redux拿回来的值
        builder: (context, language) {
          return Text(
            language['username']
          );
        },
      ),
    );
  }
}