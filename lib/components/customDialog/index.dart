import 'package:flutter/material.dart';
import '../../redux/index.dart';

// ignore: must_be_immutable
class CustomDialog extends Dialog {
  String title;
  Widget body;
  String confirmText = 'confirm';
  double height = 229;
  Map language = globalState.state.language.data;
  Function confirmCallback;
  BuildContext ctx;

  CustomDialog({Key key, String title, Widget body, double height = 229, String confirmText = 'confirm', @required Function confirmCallback, @required ctx}) : super(key: key) {
    print(title);
    this.title = title;
    this.body = body;
    this.height = height;
    this.confirmText = confirmText;
    this.confirmCallback = confirmCallback;
    this.ctx = ctx;
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 34),
      child: Text(title, style: TextStyle(color: Color(0xFF535353), fontSize: 18)),
    );
  }

  Widget buildBody() {
    return body == null ? Container() : body;
  }

  Widget buildFooter() {
    return Container(
      padding: EdgeInsets.only(left: 36, top: 14, right: 36, bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 104,
            height: 40,
            child: FlatButton(
              onPressed: cancel,
              child: Text(language['cancel'], style: TextStyle(color: Colors.white, fontSize: 15)),
              color: Color(0xFFD6D6D9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
          SizedBox(
            width: 104,
            height: 40,
            child: FlatButton(
              onPressed: confirm,
              child: Text(language[confirmText], style: TextStyle(color: Colors.white, fontSize: 15)),
              color: Color(0xFF3C96FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          )
        ],
      ),
    );
  }

  cancel() {
    Navigator.pop(ctx); 
  }

  confirm() async {
    var res = await confirmCallback();
    if (res) return cancel(); // 返回值为真则关闭对话框
  }

  @override
  Widget build(BuildContext context) {
    return new Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center( //保证控件居中效果
        child: new SizedBox(
          width: 295,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildTitle(),
                buildBody(),
                buildFooter()
              ],
            ),
          ),
        )
      )
    );
  }
}