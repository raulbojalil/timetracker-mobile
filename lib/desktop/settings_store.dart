import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingTypes {
  static const String USERNAME = "USERNAME";
  static const String PASSWORD = "PASSWORD";
  static const String PROJECT_ID = "PROJECT_ID";
  static const String ASSIGNMENT_TYPE_ID = "ASSIGNMENT_TYPE_ID";
  static const String FOCAL_POINT_ID = "FOCAL_POINT_ID";
}

//TODO: Move this to shared and use it in the mobile version too
class SettingsStore with ChangeNotifier {
  SharedPreferences prefs;

  SettingsStore(this.prefs);

  Future<bool> saveSetting(String key, String value) async {
    return this.prefs.setString(key, value);
  }

  String loadSetting(String key) {
    return this.prefs.getString(key);
  }
}
