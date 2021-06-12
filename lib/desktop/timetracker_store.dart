import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:timetracker_mobile/shared/const.dart';
import 'package:timetracker_mobile/shared/models/timetrackerentry.dart';
import 'package:timetracker_mobile/shared/timetracker.dart';

class TimeTrackerStore with ChangeNotifier {
  List<TimeTrackerEntry> _list = [];
  bool _loading = false;
  bool _saving = false;

  List<TimeTrackerEntry> get list => _list;
  bool get loading => _loading;
  bool get saving => _saving;

  TimeTrackerStore() {
    loadTimeTrackerTimes();
  }

  Future<bool> addEntry(String date, String hours, String description) async {
    _saving = true;
    notifyListeners();
    try {
      await TimeTracker.login(Constants.USERNAME, Constants.PASSWORD);

      await TimeTracker.cargaTimeTracker(date, Constants.PROJECT_ID, hours,
          Constants.ASSIGNMENT_TYPE_ID, description, Constants.FOCAL_POINT_ID);

      return true;
    } catch (e) {
      return false;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  void loadTimeTrackerTimes() async {
    _loading = true;
    notifyListeners();

    final now = DateTime.now();
    final month = now.month;
    final startDateTime = new DateTime(now.year, month, 1);
    final endDateTime =
        new DateTime(now.year, (month + 1 == 13 ? 1 : month + 1), 1)
            .subtract(Duration(days: 1));

    try {
      await TimeTracker.login(Constants.USERNAME, Constants.PASSWORD);
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
