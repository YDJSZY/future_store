import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../redux/actions.dart';
import '../../../utils/tools.dart';
import '../../../apiRequest/index.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
} 

class _Login extends State<Login> {
  String email;
  String password;
  bool emailErr = false;
  bool passwordErr = false;

  @override
  void initState() {
    super.initState();
    print('Login');
  }

  void login(setUserInfo) async {
    bool validateRes = validate();
    if (!validateRes) return;
    Map data = {'email': email, 'password': password};
    var res = await loginApp(data);
    if (res['ticLogin']['success'] && res['storeLogin']['result'] == 'success') {
      print('login成功');
      setUserInfo(res['ticLogin']['data']);
      var ff = await getEffective();
      print(ff);
    }
  }

  bool validate() {
    var correctEmail = isEmail(this.email);
    setState(() {
      emailErr = !correctEmail;
      passwordErr = (password == null);
    });
    return correctEmail && password != null;
  }

  inputOnChange(key, val) {
    if (key == 'email') {
      this.email = val;
    } else {
      this.password = val;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,//输入框抵住键盘
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
                            labelText: '请输入邮箱',
                            errorText: emailErr ? '邮箱格式错误' : ''
                          ),
                          onChanged: (val) { inputOnChange('email', val);},
                        ),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '请输入密码',
                            errorText: passwordErr ? '请输入密码' : ''
                          ),
                          onChanged: (val) { inputOnChange('password', val);},
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(top: 36, bottom: 15),
                                child: new StoreConnector<dynamic, dynamic>(
                                  converter: (store) {
                                    // Return a `VoidCallback`, which is a fancy name for a function
                                    // with no parameters. It only dispatches an Increment action.
                                    return (data) => store.dispatch({'type': Actions.SetMyInfo, 'data': data});
                                  },
                                  builder: (context, callback) {
                                    return RaisedButton(
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      color: Color(0xFF70A6FF),
                                      onPressed: () { login(callback); },
                                      child: Text('登录', style: TextStyle(color: Colors.white, fontSize: 15),),
                                    );
                                  },
                                )
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