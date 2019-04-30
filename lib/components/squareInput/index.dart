import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SquareInput extends StatefulWidget {
  int inputLen;
  Function callBack;

  SquareInput({int inputLen = 6, @required Function callBack}) {
    this.inputLen = inputLen;
    this.callBack = callBack;
  }

  @override
  State<StatefulWidget> createState() {
    return _SquareInput();
  }
}

class _SquareInput extends State<SquareInput> {
  int inputValLen = 0;
  String value;

  inputOnchange(val) {
    if (val.length > widget.inputLen) return;
    if (val.length == widget.inputLen) {
      if (widget.callBack != null) widget.callBack(val);
    }
    setState(() {
      inputValLen = val.length;
      value = val;
    });
  }

  List<Widget> buildSquare() {
    var list = List.generate(widget.inputLen, (int index) => index);
    List<Widget> children = [];
    list.forEach((item) {
      var isEnter = (item < inputValLen);
      var content = Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isEnter ? Color(0xFF70A6FF) : Color(0xFFEEEEEE),
          borderRadius: BorderRadius.all(Radius.circular(3))
        ),
      );
      children.add(content);
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: <Widget>[
            Positioned(
              top: 10,
              child: SizedBox(
                width: 243,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: buildSquare().toList(),
              ),
              ),
            ),
            Positioned(
              child: TextField(
                style: new TextStyle(color: Colors.transparent), // 文字透明
                cursorWidth: 0, // 隐藏光标
                onChanged: inputOnchange,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none, // 去掉input下划线
                  fillColor: Colors.transparent
                )
              ),
            )
          ],
        )       
      ],
    );
  }
}