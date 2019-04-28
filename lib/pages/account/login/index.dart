import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../components/toast/index.dart';
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
    instantiateShowToast();
    print('Login');
  }

  void login(setUserInfo, language) async {
    bool validateRes = validate();
    if (!validateRes) return null;
    Map data = {'email': email, 'password': password};
    var res = await loginApp(data);
    if (!res['ticLogin']['success']) {
      return showToast.error(res['ticLogin']['message']);
    }
    if (res['ticLogin']['success'] && res['storeLogin']['result'] == 'success') {
      setUserInfo(res['ticLogin']['data'], res['storeLogin']['info']);
      Navigator.of(context).pushNamed('/base');
      return null;
    }
    showToast.error(language['network_error']);
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
      body: new StoreConnector<dynamic, Map>(
        converter: (store) => store.state.language.data,
        builder: (context, language) {
          return Container(
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
                        language['login'],
                        style: TextStyle(fontSize: 24, color: Color(0xFF434343)),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                labelText: language['enter_mail_number'],
                                errorText: emailErr ? language['Wrong_format_mailbox'] : ''
                              ),
                              onChanged: (val) { inputOnChange('email', val);},
                            ),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: language['enter_password'],
                                errorText: passwordErr ? language['enter_password'] : ''
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
                                        return (ticUserInfo, storeUserInfo) {
                                          store.dispatch({'type': Actions.SetMyInfo, 'data': ticUserInfo});
                                          store.dispatch({'type': Actions.SetStoreUserInfo, 'data': storeUserInfo});
                                        };
                                      },
                                      builder: (context, callback) {
                                        return RaisedButton(
                                          padding: EdgeInsets.only(top: 15, bottom: 15),
                                          color: Color(0xFF70A6FF),
                                          onPressed: () { login(callback, language); },
                                          child: Text(language['login'], style: TextStyle(color: Colors.white, fontSize: 15),),
                                        );
                                      },
                                    )
                                  )
                                )
                              ],
                            ),
                            Text(language['forgot_password'], style: TextStyle(color: Color(0xFF70A6FF), fontSize: 13),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: RichText(
                    text: TextSpan(
                      text: '${language['no_account']}？',
                      style: TextStyle(fontSize: 13, color: Color(0xFF434343)),
                      children: <TextSpan>[
                        TextSpan(
                          text: language['sign_up'],
                          style: TextStyle(fontSize: 13, color: Color(0xFF70A6FF))
                        )
                      ]
                    ),
                  ),
                )
              ],
            )
          );
        }
      )
    );
  }
}