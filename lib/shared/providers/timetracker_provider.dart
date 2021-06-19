import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetracker_mobile/shared/models/timetrackerentry.dart';
import 'package:timetracker_mobile/shared/setting_types.dart';
import 'package:timetracker_mobile/shared/timetracker.dart';

//TODO: Move this to shared and use it in the mobile version too
class TimeTrackerProvider with ChangeNotifier {
  List<TimeTrackerEntry> _list = [];
  bool _loading = false;
  bool _saving = false;
  bool _missingData = false;

  List<TimeTrackerEntry> get list => _list;
  bool get loading => _loading;
  bool get saving => _saving;
  bool get missingData => _missingData;

  SharedPreferences prefs;

  TimeTrackerProvider(this.prefs) {
    loadTimeTrackerEntries();
  }

  Future<bool> addEntry(String date, String hours, String description) async {
    _saving = true;
    notifyListeners();
    try {
      await TimeTracker.login(this.prefs.getString(SettingTypes.USERNAME),
          this.prefs.getString(SettingTypes.PASSWORD));

      await TimeTracker.cargaTimeTracker(
          date,
          this.prefs.getString(SettingTypes.PROJECT_ID),
          hours,
          this.prefs.getString(SettingTypes.ASSIGNMENT_TYPE_ID),
          description,
          this.prefs.getString(SettingTypes.FOCAL_POINT_ID));

      return true;
    } catch (e) {
      return false;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  bool verifyData() {
    return (this.prefs.getString(SettingTypes.PROJECT_ID)?.isNotEmpty ??
            false) &&
        (this.prefs.getString(SettingTypes.ASSIGNMENT_TYPE_ID)?.isNotEmpty ??
            false) &&
        (this.prefs.getString(SettingTypes.FOCAL_POINT_ID)?.isNotEmpty ??
            false) &&
        (this.prefs.getString(SettingTypes.USERNAME)?.isNotEmpty ?? false) &&
        (this.prefs.getString(SettingTypes.PASSWORD)?.isNotEmpty ?? false);
  }

  void loadTimeTrackerEntries() async {
    if (!verifyData()) {
      _missingData = true;
      notifyListeners();
      return;
    }

    _missingData = false;
    _loading = true;
    notifyListeners();

    final now = DateTime.now();
    final month = now.month;
    final startDateTime = new DateTime(now.year, month, 1);
    final endDateTime =
        new DateTime(now.year, (month + 1 == 13 ? 1 : month + 1), 1)
            .subtract(Duration(days: 1));

    try {
      await TimeTracker.login(this.prefs.getString(SettingTypes.USERNAME),
          this.prefs.getString(SettingTypes.PASSWORD));
      var list = await TimeTracker.listaTimeTracker(
          DateFormat('dd/MM/yyyy').format(startDateTime).toString(),
          DateFormat('dd/MM/yyyy').format(endDateTime).toString());

      _list = list;
      notifyListeners();
    } catch (e) {
      _list = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
