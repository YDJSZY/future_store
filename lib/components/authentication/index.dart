import 'package:flutter/material.dart';
//import '../../pages/account/login/index.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Authentication extends StatefulWidget {
  final Widget content;

  Authentication(this.content);
  @override
  State<StatefulWidget> createState() {
    return _Authentication();
  }
}

class _Authentication extends State<Authentication> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new StoreConnector<dynamic, int>(
        converter: (store) => store.state.myInfo.infos['id'],//转换从redux拿回来的值
        builder: (context, id) {
          return id == null ? Container() : widget.content;
        },
      ),
    );
  }
}