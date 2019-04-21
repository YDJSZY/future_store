import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../redux/actions.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
} 

class _Login extends State<Login> {
  @override
  void initState() {
    super.initState();
    print('Login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(32, 113, 32, 32),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '登录',
                    style: TextStyle(fontSize: 24, color: Color(0xFF434343)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: '请输入邮箱'
                          )
                        ),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '请输入密码'
                          )
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(top: 36, bottom: 15),
                                child: RaisedButton(
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  color: Color(0xFF70A6FF),
                                  onPressed: () {},
                                  child: Text('登录', style: TextStyle(color: Colors.white, fontSize: 15),),
                                ),
                              )
                            )
                          ],
                        ),
                        Text('忘记密码', style: TextStyle(color: Color(0xFF70A6FF), fontSize: 13),)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  text: '还没有账号？',
                  style: TextStyle(fontSize: 13, color: Color(0xFF434343)),
                  children: <TextSpan>[
                    TextSpan(
                      text: '注册',
                      style: TextStyle(fontSize: 13, color: Color(0xFF70A6FF))
                    )
                  ]
                ),
              ),
            )
          ],
        )
      )
    );
  }
}