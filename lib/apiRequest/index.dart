import 'package:dio/dio.dart';
import '../config/index.dart';
import 'dart:convert';

Dio dio = Dio();
final apiPrefix = envApiConfig['apiPrefix'];
final storeApiPrefix = envApiConfig['store_apiPrefix'];
final storeSite = envApiConfig['store_site'];
final appKey = envApiConfig['app_key'];
final priceRateIsLocal = envApiConfig['price_rate_isLocal'];

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

      // get请求带有数组时
      var params = options.queryParameters;
      var url = options.path;
      var keys = params.keys.toList();
      var search = '';

      keys.forEach((key) {
        if (params[key] is List) {
          params[key].forEach((item) {
            search = '$search$key=$item&';
          });
          params.remove(key);
        }
      });
      if (search != '') {
        if (search[search.length - 1] == '&') {
          search = search.substring(0, search.length - 1);
        }
        url = '$url?$search';
        options.path = url;
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
  if (loginTicRes is String) {
    loginTicRes = json.decode(loginTicRes);
  }
  if (!loginTicRes['success']) return {'ticLogin': loginTicRes};
  var wallet = await getUserWalletInfo(loginTicRes['data']);
  var loginStoreRes = await loginStore(data);
  return {'ticLogin': loginTicRes, 'storeLogin': loginStoreRes, 'wallet': wallet};
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

getUserWalletInfo(userData) async {
  var id = userData['id'];
  var token = userData['token'];
  try {
    Response response = await dio.get(
      '${apiPrefix}walletandtoken/api/v1/wallets/query', 
      queryParameters: {'user_id': id},
      options: Options(
        extra: {'token': false},
        headers: {
          'Authorization': token
        }
      )
    );
    if (!response.data['success'] || response.data['data']['count'] == 0) {
      return await createUserWallet(token);
    }
    return response.data['data']['rows'][0];
  } catch (e) {
    print(e.error);
  }
}

createUserWallet(token) async {
  try {
    Response response = await dio.post(
      '${apiPrefix}walletandtoken/api/v1/eth/wallet', 
      options: Options(
        extra: {'token': false},
        headers: {
          'Authorization': token
        }
      )
    );
    return response.data['data'];
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

getIntegralAccountByKind(userId, kindId) async {
  var params = {
    'remote_account_id': userId,
    'integral_kind_id': kindId
  };
  try {
    Response response = await dio.get(
      '${apiPrefix}api_integral/api/v1/integral_account_kind',
      queryParameters: params
    );
    return response.data;
  } catch (e) {
    print(e.error);
  }
}

getFeeRate(params) async {
  try {
    Response response = await dio.get(
      '${apiPrefix}api_blockchain/api/v1/pickCoinFee',
      queryParameters: params
    );
    return response.data;
  } catch (e) {
    print(e.error);
  }
}

isCurrentPlatformAddress(String address) async { // 是否是本平台内的地址
  try {
    Response response = await dio.get(
      '${apiPrefix}walletandtoken/api/v1/usdt/wallet/support',
      queryParameters: {'address': address}
    );
    return response.data['data']['supported'];
  } catch (e) {
    print(e.error);
  }
}

validateWalletAddress(address) async {
  var params = {'address': address, 'currency': 'ETH', 'networkType': 'both'};
  try {
    Response response = await dio.get(
      '${apiPrefix}walletandtoken/api/v1/walletValidate',
      queryParameters: params
    );
    return response.data['data']['isValid'];
  } catch (e) {
    print(e.error);
  }
}

validatePayPassword(String password) async {
  print(password);
  try {
    Response response = await dio.post(
      '${apiPrefix}account/api/v1/pay/verify',
      data: {'password': password}
    );
    return response.data;
  } catch (e) {
    print(e.error);
  }
}

getIntegralRecords(params) async { // 积分交易记录 
  try {
    Response response = await dio.get(
      '${apiPrefix}api_integral/api/v1/integral_records',
      queryParameters: params
    );
    return response.data;
  } catch (e) {
    print(e);
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

getCategory(String index) async {
  FormData formData = new FormData.from({
    'id': index
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

getCategoryIndex() async {
  try {
    Response response = await dio.post(
      '$storeSite?m=console&c=view&a=default',
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

getProduct(Map data) async {
  FormData formData = new FormData.from({
    'number': data['number'],
    'cat_id': data['cat_id']
  });
  try {
    Response response = await dio.post(
      '$storeSite?m=console&c=view&a=product',
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

getPricingRate(Map<dynamic, dynamic> params) async { // 计价方式
  params['local'] = priceRateIsLocal.toString();
  try {
    Response response = await dio.get(
      '${apiPrefix}api_kline/api/v1/kline/token/pptr',
      queryParameters: params,
    );
    if (response.data['success']) {
      var price = response.data['data']['price'];
      return price == null ? 0 : price;
    }
    return 0;
  } catch (e) {
    print(e);
  }
}

withdrawToken(data) async {
  try {
    Response response = await dio.post(
      '${apiPrefix}api_blockchain/api/v1/eth/pickCoin',
      data: data,
    );
    return response.data;
  } catch (e) {
    print(e);
  }
}

getProductDetail(String goodsId) async {
  var params = {'m': 'goods', 'u': 0, 'id': goodsId};
  try {
    Response response = await dio.get(
      '$storeSite',
      queryParameters: params,
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