import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class Recharge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Recharge();
  }
}

class _Recharge extends State<Recharge> {
  copy(String address, String tip, ctx) {
    Clipboard.setData(new ClipboardData(text: address));
    Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(tip)));
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, dynamic>(
      converter: (store) => store.state,//转换从redux拿回来的值
      builder: (context, state) {
        var wallet = state.myInfo.wallet;
        var language = state.language.data;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF69B5F5), Color(0xFF70A6FF)]
            )
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: Text(language['deposit'], style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18)),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Builder(builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.fromLTRB(32, 10, 32, 23),
                padding: EdgeInsets.only(top: 70),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white
                ),
                child: Column(
                  children: <Widget>[
                    Text('PPTR ${language['deposit_code']}', style: TextStyle(color: Color(0xFF26262E), fontSize: 15)),
                    Container(
                      margin: EdgeInsets.only(top: 23, bottom: 23),
                      child: QrImage(
                        data: wallet['address'],
                        size: 200.0,
                      ),
                    ),
                    Text(wallet['address'], style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
                    Container(
                      margin: EdgeInsets.only(top: 60),
                      width: 100,
                      height: 40,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () => copy(wallet['address'], language['copied'], context),
                        color: Color(0xFF70A6FF),
                        child: Text(state.language.data['copy'], style: TextStyle(color: Colors.white, fontSize: 15)),
                      ),
                    )
                  ],
                ),
              );
            })
          ),
        );
      }
    );
  }
}