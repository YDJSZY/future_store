import 'package:redux/redux.dart';
import 'state.dart';
import 'reducers.dart';
import '../locale/index.dart';
import '../utils/sharedPreferences.dart';
import 'dart:convert';

var globalState;

stateInit () async {
  var userInfo = globalPrefs.getString('userInfo');
  var locale = globalPrefs.getString('locale');
  var pricingType = globalPrefs.getString('pricingType');

  globalState = Store<AppState>(mainReducer, initialState: AppState(
    myInfo: MyInfo(userInfo == null ? {} : json.decode(userInfo)), //string to map,
    storeUserInfo: StoreUserInfo({}),
    language: Language(language[locale == null ? 'zh_CN': locale]),
    pricingType: PricingType(pricingType == null ? 'CNY' : pricingType)
  ));
  return globalState;
}
