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
  ScrollController _scrollController = new ScrollController();
  int userId = globalState.state.myInfo.infos['id'];
  double balance = 0;
  var records;
  Map<String, dynamic> requestRecordParams = {'page': 1, 'size': 10, 'remote_type': 'client'};
  String exchangeRatePrice = '';
  String selectTab = 'all';
  String pricingType = globalState.state.pricingType.type;

  @override
  void initState() {
    super.initState();
    listenScroll();
    requestRecordParams['integral_kind_id'] = widget.integralKindId;
    requestRecordParams['remote_account_id'] = userId;
    _getIntegralAccountByKind();
    _getTransactionRecord(requestRecordParams);
  }

  listenScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==  _scrollController.position.maxScrollExtent) {
        requestRecordByPage(++requestRecordParams['page']);
      }
    });
  }

  _getIntegralAccountByKind() async {
    var res = await getIntegralAccountByKind(userId, widget.integralKindId);
    if (res['success']) {
      var _balance = divPrecision(val: res['data']['balance']);
      _getPricingRate(_balance);
      setState(() {
        balance = _balance;
      });
    }
  }

  _getTransactionRecord(params) async {
    var selectTabData = tabTypes.where((item) => item['text'] == selectTab).toList()[0];
    var key = selectTabData['key'];
    if (key != null) {
      params[key] = selectTabData['value'].split('&');
    }
    var res = await getIntegralRecords(params);
    if (res['data']['results'].length == 0) --requestRecordParams['page'];
    if (res['success']) {
      var list = records;
      if (params['page'] == 1) {
        list = res['data']['results'];
      } else {
        list = list..addAll(res['data']['results']);
      }
      setState(() {
        records = list;
      });
    }
  }

  _getPricingRate(balance) async {
    var params = {'curno': pricingType};
    var res = await getPricingRate(params);
    if (res is String) {
      res = double.parse(res);
    }
    exchangeRatePrice = (balance * res).toString();
    setState(() {
      exchangeRatePrice = exchangeRatePrice;
    });
  }

  Future onRefresh() async {
    await requestRecordByPage(1);
  }

  requestRecordByPage(int page) async {
    requestRecordParams['page'] = page;
    Map<String, dynamic> _requestRecordParams = Map.from(requestRecordParams);
    return await _getTransactionRecord(_requestRecordParams);
  }

  onSelectTab(String tab) {
    if (tab == selectTab) return;
    setState(() {
      selectTab = tab;
      records = null;
    });
    requestRecordByPage(1);
  }

  goto(String path) {
    Navigator.pushNamed(context, path);
  }

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

  Widget buildNoData() {
    var language = globalState.state.language.data;
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text(language['no_data'], style: TextStyle(fontSize: 16)),
    );
  }

  Widget buildRecordDetail() {
    return Expanded(
      child: Container(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: records == null ? Container() : (records.length == 0 ? buildNoData() : ListView.builder(
            itemCount: records.length,
            controller: _scrollController,
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
          )),
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
              color: Color(0xFF26262E), //change your color here
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
          bottomNavigationBar: BottomAppBar(
            child: Container(
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
                        onPressed: () => goto('/withdraw'),
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        color: Colors.white,
                        child: Text(state.language.data['withdraw'], style: TextStyle(color: Color(0xFF70A6FF), fontSize: 15)),
                      ),
                    )
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () => goto('/recharge'),
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      color: Color(0xFF70A6FF),
                      child: Text(state.language.data['deposit'], style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  )
                ],
              ),
            )
          )
        );
      }
    );
  }
}