import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';
import '../../redux/index.dart';
import '../../utils/tools.dart';

class WithdrawToken extends StatefulWidget {
  final int integralKindId;

  WithdrawToken(this.integralKindId);

  @override
  State<StatefulWidget> createState() {
    return _WithdrawToken();
  }
}

class _WithdrawToken extends State<WithdrawToken> {
  int userId = globalState.state.myInfo.infos['id'];
  double balance;
  @override
  void initState() {
    super.initState();
    _getIntegralAccountByKind();
  }

  _getIntegralAccountByKind() async {
    var res = await getIntegralAccountByKind(userId, widget.integralKindId);
    print(res);
    if (res['success']) {
      var _balance = divPrecision(val: res['data']['balance']);
      setState(() {
        balance = _balance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, dynamic>(
      converter: (store) => store.state,
      builder: (context, state) {
        var language = state.language.data;
        return Scaffold(
          resizeToAvoidBottomPadding: false,//输入框抵住键盘
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF26262E), //change your color here
            ),
            title: Text(language['withdraw'], style: TextStyle(color: Color(0xFF26262E), fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Color(0xFFF3F4F6),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 12),
                  padding: EdgeInsets.only(left: 17, right: 17, top: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(language['withdraw_address'], style: TextStyle(color: Color(0xFF313131), fontSize: 13)),
                          Text('${language['balance']}: $balance PPTR', style: TextStyle(color: Color(0xFF70A6FF), fontSize: 11))
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none, // 去掉input下划线
                          labelText: language['input_withdraw_address'],
                        ),
                        //onChanged: (val) { inputOnChange('password', val);},
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 12),
                  padding: EdgeInsets.only(left: 17, right: 17, top: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(language['withdraw_amount'], style: TextStyle(color: Color(0xFF313131), fontSize: 13)),
                          Text('${language['donate_fee']}: ', style: TextStyle(color: Color(0xFF70A6FF), fontSize: 11))
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none, // 去掉input下划线
                          labelText: language['minimum_withdraw_amount'],
                        ),
                        //onChanged: (val) { inputOnChange('password', val);},
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  width: 247,
                  child: FlatButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    color: Color(0xFF70A6FF),
                    child: Text(language['submit_application'], style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                )
              ],
            ),
          )
        );
      }
    );
  }
}