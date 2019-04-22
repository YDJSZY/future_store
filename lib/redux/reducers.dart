import 'dart:convert';
import 'actions.dart';
import 'state.dart';
import '../locale/index.dart';
import '../utils/sharedPreferences.dart';

AppState mainReducer(AppState state, dynamic action){

  if (action['type'] == Actions.SetMyInfo) {
    globalPrefs.setString('userInfo', json.encode(action['data']));
    state.myInfo.infos = action['data'];
    return state;
  }

  if (action['type'] == Actions.SetLanguage) {
    globalPrefs.setString('locale', action['data']);
    state.language.data = language[action['data']];
    return state;
  }

  if (action['type'] == Actions.SetStoreUserInfo) {
    state.storeUserInfo.infos = action['data'];
  }

  return state;
}