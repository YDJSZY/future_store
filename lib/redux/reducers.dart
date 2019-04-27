import 'dart:convert';
import 'actions.dart';
import 'state.dart';
import '../locale/index.dart';
import '../utils/sharedPreferences.dart';

AppState mainReducer(AppState state, dynamic action) {
  switch (action['type']) {
    case Actions.SetMyInfo:
      globalPrefs.setString('userInfo', json.encode(action['data']));
      state.myInfo.infos = action['data'];
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
      state.myInfo.infos = {};
      state.storeUserInfo.infos = {};
      return state;

    case Actions.SetPricingType:
      state.pricingType.type = action['data'];
      return state;

    default:
      return state;
  }
}