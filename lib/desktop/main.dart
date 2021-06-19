import 'package:fluent_ui/fluent_ui.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetracker_mobile/desktop/theme.dart';
import 'package:timetracker_mobile/shared/providers/settings_provider.dart';
import 'package:timetracker_mobile/shared/providers/timetracker_provider.dart';

import 'screens/home.dart';

runDesktopApp() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TimeTrackerProvider(prefs)),
      ChangeNotifierProvider(create: (_) => AppTheme(prefs)),
      ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
    ],
    child: const MyApp(),
  ));
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = Size(755, 640);
    win.size = Size(755, 640);
    win.alignment = Alignment.center;
    win.title = "BairesDev Time Tracker";
    win.show();
  });
}

bool darkMode = false;

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();

    return FluentApp(
      title: '',
      themeMode: appTheme.mode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (_) => Home()},
      theme: ThemeData(
        accentColor: appTheme.color,
        brightness: appTheme.mode == ThemeMode.system
            ? darkMode
                ? Brightness.dark
                : Brightness.light
            : appTheme.mode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
      ),
    );
  }
}
