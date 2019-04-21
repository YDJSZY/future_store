import 'package:redux/redux.dart';
import 'state.dart';
import 'reducers.dart';
import '../locale/index.dart';
// import 'dart:convert';

var globalState;

stateInit () async {
  globalState = Store<AppState>(mainReducer, initialState: AppState(
    myInfo: MyInfo({'username': 'errrr'}),
    language: Language(language['zh_CN'])
  ));
  return globalState;
}
