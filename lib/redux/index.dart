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
  var wallet = globalPrefs.getString('wallet');
  if (pricingType == null) globalPrefs.setString('pricingType', 'CNY');

  globalState = Store<AppState>(mainReducer, initialState: AppState(
    myInfo: MyInfo(userInfo == null ? {} : json.decode(userInfo), wallet == null ? {} : json.decode(wallet)), //string to map,
    storeUserInfo: StoreUserInfo({}),
    language: Language(language[locale == null ? 'zh_CN': locale]),
    pricingType: PricingType(pricingType == null ? 'CNY' : pricingType),
    locale: Locale(locale == null ? 'zh_CN' : locale)
  ));
  return globalState;
}
