import 'actions.dart';
import 'state.dart';
import '../locale/index.dart';

AppState mainReducer(AppState state, dynamic action){

  if (action['type'] == Actions.SetMyInfo) {
    state.myInfo.infos = action['data'];
    return state;
  }

  if (action['type'] == Actions.SetLanguage) {
    state.language.data = language[action['data']];
    return state;
  }

  return state;
}