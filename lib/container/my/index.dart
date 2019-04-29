import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../redux/index.dart';
import '../../redux/actions.dart';
import 'myAssets/index.dart';
import 'myOrderService/index.dart';

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
  }

  logout() {
    globalState.dispatch({'type': Actions.Logout});
  }

  gotoSetting() {
    Navigator.pushNamed(context, '/setting');
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<dynamic, dynamic>(
      converter: (store) => store.state,//转换从redux拿回来的值
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFFF3F4F6),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 228,
                    padding: EdgeInsets.only(top: 40, left: 16, right: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF525252), Color(0xFF1F1F1F)]
                      )
                    ), // 渐变背景色
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              IconData(
                                0xe6af, 
                                fontFamily: 'iconfont'
                              ),
                              color: Colors.white,
                              size: 26,
                            ),
                            GestureDetector(
                              onTap: gotoSetting,
                              child: Icon(
                                IconData(
                                  0xe6b2, 
                                  fontFamily: 'iconfont'
                                ),
                                color: Colors.white,
                                size: 26,
                              )
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 65,
                              height: 65,
                              child: CircleAvatar(
                                backgroundImage: AssetImage('lib/assets/imgs/head.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(state.myInfo.infos['email'], style: TextStyle(color: Colors.white, fontSize: 18),),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -50),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          MyAssets(),
                          MyOrderService()
                        ],
                      ),
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