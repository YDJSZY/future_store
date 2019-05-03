import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';
import '../../redux/index.dart';
import '../../utils/tools.dart';
import '../../components/toast/index.dart';
import '../../components/modalPassword/index.dart';
import '../result/index.dart';

class WithdrawToken extends StatefulWidget {
  final int integralKindId;
  final int tokenId;

  WithdrawToken(this.integralKindId, this.tokenId);

  @override
  State<StatefulWidget> createState() {
    return _WithdrawToken();
  }
}

class _WithdrawToken extends State<WithdrawToken> {
  int userId = globalState.state.myInfo.infos['id'];
  Map language = globalState.state.language.data;
  String feeText = '--';
  double feeRate = 0;
  num least;
  double maxAmount;
  String amount = '';
  String address = '';
  double balance;
  //TextEditingController _amountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    instantiateShowToast();
    _getIntegralAccountByKind();
    _getFeeRate();
  }

  _getIntegralAccountByKind() async {
    var res = await getIntegralAccountByKind(userId, widget.integralKindId);
    if (res['success']) {
      var _balance = divPrecision(val: res['data']['balance']);
      setState(() {
        balance = _balance;
      });
    }
  }

  _getFeeRate() async {
    const params = {'token_name': 'PPTR'};
    var res = await getFeeRate(params);
    print(res);
    if (res['success']) {
      var data = res['data']['rows'][0];
      setState(() {
        feeRate = double.parse(data['fee_rate']) / 100;
        least = divPrecision(val: data['min_pick_amount']);
        maxAmount = divPrecision(val: data['max_amount']);
      });
    }
  }

  addressOnChange(val) {
    setState(() {
      address = val;
    });
  }

  submit() async {
    if (amount == '' || address == '') return;
    if (!await validate()) return;
    showPasswordModal();
  }

  validate() async {
    if (!await validateWalletAddress(address)) {
      showToast.error(language['enter_valid_address']);
      return false;
    }
    if (await isCurrentPlatformAddress(address)) { // 是否是平台内的地址
      showToast.error(language['platform_address_invalid']);
      return false;
    }
    if (num.parse(amount) < least) {
      showToast.error(language['error_minimum_withdraw_amount']);
      return false;
    }
    if (balance < num.parse(feeText) || num.parse(amount) > balance) {
      showToast.error(language['balance_not_enough']);
      return false;
    }
    return true;
  }

  showPasswordModal() {
    showDialog<Null>(
    context: context, //BuildContext对象
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ModalPassword(context, commitSubmit);
    });
  }

  commitSubmit() async {
    var data = {
      'sender_id': userId,
      'integral_kind_id': widget.integralKindId, // 币种
      'token_id': widget.tokenId, // 币地址
      'receive_address': address, // 提币地址 0x48A6004960D976308B3afdF29D70075814380B80
      'amount': mulPrecision(val: amount).toStringAsFixed(0), // 提币数量
      'origin': 'app',  
      'only': 'pptr',
      'token_name': 'PPTR'
    };
    print(data);
    var res = await withdrawToken(data);
    if (!res['success']) return showToast.error(language['network_error']);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => Result(language['withdraw_application'], language['apply_results'], true))
    );
  }

  amountChange(val) {
    var _feeText = val == '' ? '--' : (feeRate * num.parse(val)).toStringAsFixed(2);
    setState(() {
      amount = val;
      feeText = _feeText;
    });
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
                        onChanged: addressOnChange,
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
                          Text('${language['donate_fee']}: $feeText', style: TextStyle(color: Color(0xFF70A6FF), fontSize: 11))
                        ],
                      ),
                      TextField(
                        //controller: _amountCtrl,
                        keyboardType: TextInputType.number, // 数字键盘优先
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//只允许输入数字
                        decoration: InputDecoration(
                          border: InputBorder.none, // 去掉input下划线
                          labelText: '${language['minimum_withdraw_amount']} $least',
                        ),
                        onChanged: amountChange
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  width: 247,
                  child: FlatButton(
                    onPressed: submit,
                    disabledColor: Color(0xFF69BFF1),
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