import 'package:flutter/material.dart';
import '../../redux/index.dart';
import '../../apiRequest/index.dart';
import '../customDialog/index.dart';
import '../squareInput/index.dart';

class ModalPassword extends StatefulWidget {
  final BuildContext ctx;

  ModalPassword(this.ctx);

  @override
  State<StatefulWidget> createState() {
    return _ModalPassword();
  }
}

class _ModalPassword extends State<ModalPassword> {
  bool canPay = globalState.state.myInfo.infos['can_pay'];
  String title;
  String password;

  @override
  void initState() {
    super.initState();
    title = canPay ? '请输入支付密码' : '请设置密码';
  }

  validatePassword() async {
    print(password);
    var res = await validatePayPassword(password);
    print(res);
    return res['success'];
  }

  savePassword(psd) {
    setState(() {
      password = psd;
    });
    print(password);
  }

  buildModalBody() {
    if (canPay) {
      return Padding(
        padding: EdgeInsets.only(left: 26, right: 26),
        child: Column(
          children: <Widget>[
            SquareInput(callBack: savePassword),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 5),
              child: Text('忘记密码?', style: TextStyle(color: Color(0xFF70A6FF), fontSize: 13)),
            )
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(title: title, body: buildModalBody(), ctx: widget.ctx, confirmCallback: validatePassword,);
  }
}