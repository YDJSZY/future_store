import 'package:flutter/material.dart';
import 'pages/account/login/index.dart';
import 'container/index.dart';
import 'pages/setting/index.dart';

authenticationRoute(RouteSettings settings, bool isLogin) {
  switch (settings.name) {
    case '/':
      return _authenticationLogin(isLogin, FutureStore());

    case '/setting':
      return _authenticationLogin(isLogin, Setting());
      
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