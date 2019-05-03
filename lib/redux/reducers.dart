import 'dart:convert';
import 'actions.dart';
import 'state.dart';
import '../locale/index.dart';
import '../utils/sharedPreferences.dart';

AppState mainReducer(AppState state, dynamic action) {
  switch (action['type']) {
    case Actions.SetMyInfo:
      var key = action['key'];
      globalPrefs.setString(key, json.encode(action['data']));
      if (key == 'userInfo') {
        state.myInfo.infos = action['data'];
      } else {
        state.myInfo.wallet = action['data'];
      }
      return state;

    case Actions.SetLanguage:
      globalPrefs.setString('locale', action['data']);
      state.language.data = language[action['data']];
      return state;

    case Actions.SetStoreUserInfo:
      state.storeUserInfo.infos = action['data'];
      return state;

    case Actions.Logout:
      globalPrefs.setString('userInfo', null);
      globalPrefs.setString('wallet', null);
      state.myInfo.infos = {};
      state.myInfo.wallet = {};
      state.storeUserInfo.infos = {};
      return state;

    case Actions.SetPricingType:
      state.pricingType.type = action['data'];
      return state;

    case Actions.SetSelectToken:
      state.selectToken.token = action['data'];
      return state;

    default:
      return state;
  }
}