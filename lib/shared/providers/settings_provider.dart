import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO: Move this to shared and use it in the mobile version too
class SettingsProvider with ChangeNotifier {
  SharedPreferences prefs;

  SettingsProvider(this.prefs);

  Future<bool> saveSetting(String key, String value) async {
    return this.prefs.setString(key, value);
  }

  String loadSetting(String key) {
    return this.prefs.getString(key);
  }
}
