import 'package:flutter/material.dart';
import '../../redux/index.dart';
import '../../redux/actions.dart';

class My extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _My();
  }
}

class _My extends State<My> {
  @override
  void initState() {
    super.initState();
    print(globalState);
  }

  logout() {
    globalState.dispatch({'type': Actions.Logout});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: logout,
        color: Colors.red,
        child: Text('logout'),
      ),
    );
  }
}