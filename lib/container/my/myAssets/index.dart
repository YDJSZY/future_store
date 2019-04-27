import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../apiRequest/index.dart';
import '../../../redux/index.dart';
import '../../../utils/tools.dart';

const Map pricingTypeSign = {
  'CNY': '¥',
  'USD': '\$',
  'KRW': '₩',
  'JPY': '¥'
};
  
class MyAssets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAssets();
  }
}

class _MyAssets extends State<MyAssets> {
  Map integralAccount = {'balance': 0};
  String pricingType = globalState.state.pricingType.type;
  double priceRate = 0;
  String exchangeRatePrice = '';

  @override
  void initState() {
    super.initState();
    _getIntegralAccount(globalState.state.myInfo.infos['id']);
  }

  _getIntegralAccount(userId) async {
    var res = await getIntegralAccount(userId);
    if (!res['success']) return;

    List data = res['data'];
    var _integralAccount = data.where((item) => item['symbol'] == 'PPTR').toList()[0];
    _integralAccount['balance'] = divPrecision(val: _integralAccount['balance']);
    setState(() {
      integralAccount = _integralAccount;
    });
    _getPricingRate();
  }

  _getPricingRate() async {
    var params = {'curno': pricingType};
    var res = await getPricingRate(params);
    exchangeRatePrice = (integralAccount['balance'] * res).toString();
    setState(() {
      priceRate = res;
      exchangeRatePrice = exchangeRatePrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, dynamic>(
      converter: (store) => store.state,//转换从redux拿回来的值
      builder: (context, state) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  children: <Widget>[
                    Text('${state.language.data['total_assets']} (PPTR)'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(),
                        Padding(
                          padding: EdgeInsets.only(left: 27, top: 16, bottom: 8),
                          child: Text(integralAccount['balance'].toString(), style: TextStyle(fontSize: 24, color: Color(0xFF000000)),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 17),
                          child: Icon(
                            IconData(
                              0xe69c, 
                              fontFamily: 'iconfont'
                            ),
                            color: Color(0xFFA0A0A0),
                            size: 14,
                          )
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 18),
                      child: Text('≈${pricingTypeSign[pricingType]} $exchangeRatePrice', style: TextStyle(color: Color(0xFF000000), fontSize: 12),),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1, color: Color(0xFFE5E5E5)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(right: BorderSide(width: 1, color: Color(0xFFE5E5E5)))
                                ),
                                child: Text(state.language.data['withdraw'], style: TextStyle(color: Color(0xFF000000), fontSize: 13),),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(state.language.data['deposit'], style: TextStyle(color: Color(0xFF000000), fontSize: 13),),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }
}