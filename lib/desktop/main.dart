import 'package:fluent_ui/fluent_ui.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'home_page_widget/home_page_widget.dart';

runDesktopApp() {
  runApp(MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = Size(410, 640);
    win.size = Size(755, 545);
    win.alignment = Alignment.center;
    win.title = "BairesDev Time Tracker";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "BairesDev Time Tracker",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (_) => MyHomePage()},
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
      ),
    );
  }
}
