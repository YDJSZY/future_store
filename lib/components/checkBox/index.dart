import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatelessWidget {
  bool value = false;
  Function onChange;

  CustomCheckBox(this.value, this.onChange);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          border: Border.all(width: 1, color: value ? Colors.transparent : Color(0xFFA0A0A0)),
          color: value ? Color(0xFF70A6FF) : Colors.white
        ),
        child: Icon(
          IconData(
            0xe6bb, 
            fontFamily: 'iconfont'
          ),
          color: Colors.white,
          size: 16.5,
        ),
      )
    );
  }
}