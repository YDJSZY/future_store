import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

// ignore: must_be_immutable
class Result extends StatelessWidget {
  String title;
  String desc;
  String subDesc;
  Function beforeBack;
  bool status;

  Result(this.title, this.desc, this.status, {Function beforeBack, String subDesc}) {
    this.beforeBack = beforeBack;
    this.subDesc = subDesc;
  }

  back(BuildContext context) {
    if (beforeBack != null) beforeBack();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var statusImg = status ? 'lib/assets/imgs/check.png' : 'lib/assets/imgs/attention.png';
    return new StoreConnector<dynamic, dynamic>(
      converter: (store) => store.state,
      builder: (context, state) {
        var language = state.language.data;
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF26262E), //change your color here
            ),
            title: Text(title, style: TextStyle(color: Color(0xFF26262E), fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Color(0xFFF3F4F6),
          body: Container(
            padding: EdgeInsets.only(top: 47),
            child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset(statusImg, width: 60, height: 60),
                  Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 12),
                    child: Text(desc, style: TextStyle(color: Color(0xFF535353), fontSize: 15)),
                  ),
                  Text(desc, style: TextStyle(color: Color(0xFF535353), fontSize: 13)),
                  Container(
                    margin: EdgeInsets.only(top: 60),
                    width: 190,
                    height: 44,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () => back(context),
                      color: Color(0xFF70A6FF),
                      child: Text(language['back'], style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}