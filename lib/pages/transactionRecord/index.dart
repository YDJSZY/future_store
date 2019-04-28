import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../apiRequest/index.dart';
import '../../redux/index.dart';
import '../../utils/tools.dart';
import 'utils.dart';

const Map pricingTypeSign = {
  'CNY': '¥',
  'USD': '\$',
  'KRW': '₩',
  'JPY': '¥'
};

const List<Map> tabTypes = [
  {'text': 'all'},
  {'value': 'recharge', 'text': 'charge_money', 'key': 'operate_type'},
  {'value': 'pickCoin&pickCoinFee', 'text': 'withdraw', 'key': 'operate_type'},
  {'value': '1', 'text': 'income', 'key': 'change_type'},
  {'value': '-1', 'text': 'expend', 'key': 'change_type'},
];

class TransactionRecord extends StatefulWidget {
  final int integralKindId;

  TransactionRecord(this.integralKindId);

  @override
  State<StatefulWidget> createState() {
    return _TransactionRecord();
  }
}

class _TransactionRecord extends State<TransactionRecord> {
  int userId = globalState.state.myInfo.infos['id'];
  double balance = 0;
  List records = [];
  Map<String, dynamic> requestRecordParams = {'page': 1, 'size': 10, 'remote_type': 'client'};
  String exchangeRatePrice = '';
  String selectTab = 'all';
  String pricingType = globalState.state.pricingType.type;

  @override
  void initState() {
    super.initState();
    requestRecordParams['integral_kind_id'] = widget.integralKindId;
    requestRecordParams['remote_account_id'] = userId;
    _getIntegralAccountByKind();
    _getTransactionRecord(requestRecordParams);
  }

  _getIntegralAccountByKind() async {
    var res = await getIntegralAccountByKind(userId, widget.integralKindId);
    _getPricingRate();
    if (res['success']) {
      var _balance = divPrecision(val: res['data']['balance']);
      setState(() {
        balance = _balance;
      });
    }
  }

  _getTransactionRecord(requestRecordParams) async {
    var selectTabData = tabTypes.where((item) => item['text'] == selectTab).toList()[0];
    var key = selectTabData['key'];
    if (key != null) {
      requestRecordParams[key] = selectTabData['value'].split('&');
    }
    var res = await getIntegralRecords(requestRecordParams);
    if (res['success']) {
      setState(() {
        records = res['data']['results'];
      });
    }
  }

  _getPricingRate() async {
    var params = {'curno': pricingType};
    var res = await getPricingRate(params);
    print(res);
    print(balance * res);
    exchangeRatePrice = (balance * res).toString();
    setState(() {
      exchangeRatePrice = exchangeRatePrice;
    });
  }

  Future onRefresh() async {

  }

  onSelectTab(String tab) {
    setState(() {
      selectTab = tab;
    });
    Map<String, dynamic> _requestRecordParams = Map.from(requestRecordParams);
    _requestRecordParams['page'] = 1;
    _getTransactionRecord(_requestRecordParams);
  }

  gotoWithdraw() {}

  Widget buildBalance(pricingType) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20, bottom: 40),
      color: Color(0xFFF3F4F6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('lib/assets/imgs/platform_token_ss.png', width: 50, height: 50,),
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Text(balance.toString(), style: TextStyle(color: Color(0xFF313131), fontSize: 24),),
          ),
          Text('≈${pricingTypeSign[pricingType]} $exchangeRatePrice', style: TextStyle(color: Color(0xFF000000), fontSize: 12),),
        ],
      ),
    );
  }

  Widget buildRecord() {
    return Expanded(
      child: Transform.translate(
        offset: Offset(0, -20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white
          ),
          child: Column(
            children: <Widget>[
              buildTab(),
              buildRecordDetail()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecordDetail() {
    return Expanded(
      child: Container(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            itemCount: records.length,
            itemBuilder: (BuildContext context, int index){
              var record = records[index];
              var operateType = record['operate_type'];
              var createdAt = record['created_at'];
              var amount = divPrecision(val: record['amount']).toString();
              var changeType = record['change_type'];
              var status = record['status'];
              return Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                padding: EdgeInsets.only(top: 13, bottom: 13),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F4F6)))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(getTransactionType(operateType), style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(createdAt, style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 13)),
                        )
                      ],
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          Text('${getChangeType(changeType)} $amount PPTR', style: TextStyle(color: Color(0xFF535353), fontSize: 13)),
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(getTransactionStatus(status), style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 13)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      )
    );
  }

  Widget buildTab() {
    var language = globalState.state.language.data;
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F4F6))),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: (() {
          List<Widget> list = []; 
          tabTypes.forEach((item) {
            var text = item['text'];
            var isSelectTab = selectTab == text;
            var content = GestureDetector(
              onTap: () => onSelectTab(text),
              child: Container(
                height: 28,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 20, left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: isSelectTab ? Color(0xFF70A6FF) : Colors.white
                ),
                child: Text(language[text], style: TextStyle(color: isSelectTab ? Colors.white : Color(0xFF313131), fontSize: 15),),
              ),
            );
            list.add(content);
          });
          return list;
        })(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, dynamic>(
      converter: (store) => store.state,//转换从redux拿回来的值
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF000000), //change your color here
            ),
            title: Text('PPTR', style: TextStyle(color: Color(0xFF26262E), fontSize: 18),),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                buildBalance(state.pricingType.type),
                buildRecord(),
              ],
            ),
          ),
          bottomSheet: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: OutlineButton(
                      borderSide: BorderSide(width: 1, color: Color(0xFF70A6FF)),
                      onPressed: gotoWithdraw,
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      color: Colors.white,
                      child: Text(state.language.data['withdraw'], style: TextStyle(color: Color(0xFF70A6FF), fontSize: 15)),
                    ),
                  )
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: gotoWithdraw,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    color: Color(0xFF70A6FF),
                    child: Text(state.language.data['deposit'], style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}