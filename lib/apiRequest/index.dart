import 'package:dio/dio.dart';
import '../config/index.dart';
import 'dart:convert';

Dio dio = Dio();
final apiPrefix = envApiConfig['apiPrefix'];
final storeApiPrefix = envApiConfig['store_apiPrefix'];
final storeSite = envApiConfig['store_site'];
final appKey = envApiConfig['app_key'];

dioConfig(store, navigatorKey) {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      var ticToken;
      var storeToken;
      if (options.extra['token'] != false) {
        ticToken = store.state.myInfo.infos['token'];
        storeToken = store.state.storeUserInfo.infos['token'];
        if (options.extra['store'] == true) {
          options.queryParameters['origin'] = 'app';
          options.queryParameters['openid'] = appKey;
          options.queryParameters['token'] = storeToken;
        } else {
          options.headers['Authorization'] = ticToken;
        }
      }
     // 在请求被发送之前做一些事情
      return options; //continue
     // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
     // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
     //
     // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
     // 这样请求将被中止并触发异常，上层catchError会被调用。
    },
    onResponse: (Response response) {
      if (response.statusCode == 401) { // token失效
        navigatorKey.currentState.pushNamed('/login');
      }
      if (response == null) return {'success': false, 'data': null};
      return response; // continue
    },
    onError: (DioError e) {
      // 当请求失败时做一些预处理
      if (e.response?.statusCode == 401) {
        navigatorKey.currentState.pushNamed('/login');
        return {'success': false, 'data': '登录失效'};
      }
      return e;//continue
    }
  ));
}

loginApp(Map data) async {
  var loginTicRes = await loginTic(data);
  var loginStoreRes = await loginStore(data);
  return {'ticLogin': loginTicRes, 'storeLogin': loginStoreRes};
}

loginTic(data) async {
  try {
    Response response = await dio.post(
      '${apiPrefix}api/v1/login', 
      data: data,
      options: Options(
        extra: {'token': false}
      ));
    return response.data;
  } catch (e) {
    print(e.error);
  }
}

loginStore(data) async {
  Map userData = {'user_name': data['email'], 'password': data['password']};
  FormData formData = new FormData.from({
    'methods': 'dsc.user.login.post',
    'app_key': appKey,
    'data': json.encode(userData)
  });
  try {
    Response response = await dio.post(
      storeApiPrefix, 
      data: formData,
      options: Options(
        extra: {'token': false}
      ));
    return response.data;
  } catch (e) {
    print(e.error);
  }
}

getIntegralAccount(userId) async {
  try {
    Response response = await dio.get(
      '${apiPrefix}api_integral/api/v1/integral_account/$userId',
    );
    return response.data;
  } catch (e) {
    print(e.error);
  }
}

getEffective() async {
  try {
    Response response = await dio.get(
      '${apiPrefix}api_futureshop/api/v1/rewardPool/effective',
    );
    return response.data;
  } catch (e) {
    print(e.error);
  }
}

receiveReward(bonusId) async {
  try {
    Response response = await dio.get(
      '${apiPrefix}api_futureshop/api/v1/rewardPool/receive/$bonusId',
    );
    return response.data;
  } catch (e) {
    print(e.error);
  }
}

getStoreHomeData() async { // 商城首页数据
  FormData formData = new FormData.from({
    'id': '3'
  });
  try {
    Response response = await dio.post(
      '$storeSite?m=console&c=view&a=view',
      data: formData,
      options: Options(
        extra: {'store': true},
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        }
      )
    );
    return response.data;
  } catch (e) {
    print(e.error);
  }
}