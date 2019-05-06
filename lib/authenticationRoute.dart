import 'package:flutter/material.dart';
import 'pages/account/login/index.dart';
import 'container/index.dart';
import 'pages/setting/index.dart';
import 'pages/recharge/index.dart';
import 'pages/shoppingCart/index.dart';

authenticationRoute(RouteSettings settings, bool isLogin) {
  switch (settings.name) {
    case '/':
      return _authenticationLogin(isLogin, FutureStore());

    case '/recharge':
      return _authenticationLogin(isLogin, Recharge());

    case '/setting':
      return _authenticationLogin(isLogin, Setting());

    case '/shoppingCart':
      return _authenticationLogin(isLogin, ShoppingCart());
      
    case '/login':
      return MaterialPageRoute(builder: (_) {
        return Login();
      });
  }
}

_authenticationLogin(isLogin, page) {
  return MaterialPageRoute(builder: (_) {
    return isLogin ? page : Login();
  });
}