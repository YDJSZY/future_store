import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MyOrderService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyOrderService();
  }
}

class _MyOrderService extends State<MyOrderService> {
  List<Map> orderType = [
    {'font': 0xe6aa, 'text': 'payment_awaiting'},
    {'font': 0xe69b, 'text': 'to_be_shipped'},
    {'font': 0xe6a8, 'text': 'goods_to_be_received'},
    {'font': 0xe6ac, 'text': 'wait_evaluate'}
  ];
  List<Map> serviceType = [
    {'font': 0xe6a9, 'text': 'set_up_shop'},
    {'font': 0xe6c5, 'text': 'caifutong'},
    {'font': 0xe6b7, 'text': 'invite_friends'},
    {'font': 0xe6b9, 'text': 'my_performance'}
  ];

  @override
  void initState() {
    super.initState();
  }

  List<Widget> buildOrderType(language, type, color) {
    List<Widget> list = [];
    type.forEach((item) {
      var content = GestureDetector(
        child: Column(
          children: <Widget>[
            Icon(
              IconData(
                item['font'], 
                fontFamily: 'iconfont'
              ),
              color: Color(color),
              size: 28,
            ),
            Padding(
              padding: EdgeInsets.only(top: 11),
              child: Text(language[item['text']], style: TextStyle(color: Color(0xFF313131), fontSize: 11),),
            )
          ],
        )
      );
      list.add(content);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, dynamic>(
      converter: (store) => store.state,//转换从redux拿回来的值
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(left: 17, right: 17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(state.language.data['my_orders'], style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Text(state.language.data['look_at_all'], style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 13)),
                                Icon(
                                  IconData(
                                    0xe69c, 
                                    fontFamily: 'iconfont'
                                  ),
                                  color: Color(0xFFA0A0A0),
                                  size: 12,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 24, bottom: 24, left: 15, right: 15),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1, color: Color(0xFFF3F4F6)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: buildOrderType(state.language.data, orderType, 0xFFF9D122).toList(),
                      ),
                    )
                  ],
                ),
              ), //我的订单
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(state.language.data['my_server'], style: TextStyle(color: Color(0xFF313131), fontSize: 15)),
                        ]
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 24, bottom: 24, left: 15, right: 15),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1, color: Color(0xFFF3F4F6)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: buildOrderType(state.language.data, serviceType, 0xFF70A6FF).toList(),
                      ),
                    )
                  ]
                )
              )
            ],
          ),
        );
      }
    );
  }
}