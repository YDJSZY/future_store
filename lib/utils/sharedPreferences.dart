import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences globalPrefs;
_getGlobalPrefs () async {
  globalPrefs = await SharedPreferences.getInstance();
  return globalPrefs;
}

initSharedPreferences() async {
  return await _getGlobalPrefs();
}