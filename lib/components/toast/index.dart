import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

ShowToast showToast;

getPosition(position) {
  switch (position) {
    case 'top':
      return ToastGravity.TOP;
    case 'center':
      return ToastGravity.CENTER;
    case 'bottom':
      return ToastGravity.BOTTOM;
  }
}

class ShowToast {
  success(msg, {gravity = 'center'}) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: getPosition(gravity),
      backgroundColor: Color(0xFF15D78D),
      textColor: Colors.white
    );
  }

  error(msg, {gravity = 'center'}) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: getPosition(gravity),
      backgroundColor: Colors.red,
      textColor: Colors.white
    );
  }
}

ShowToast instantiateShowToast() {
  showToast = ShowToast();
  return showToast;
}