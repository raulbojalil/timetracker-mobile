import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_mobile/desktop/screens/web.dart';
import 'package:timetracker_mobile/desktop/timetracker_store.dart';
import 'entries.dart';
import 'settings.dart';
import '../theme.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool value = false;

  int index = 0;

  final colorsController = ScrollController();
  final settingsController = ScrollController();

  @override
  void dispose() {
    colorsController.dispose();
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    final ttStore = context.watch<TimeTrackerStore>();
    return NavigationView(
      useAcrylic: false,
      pane: NavigationPane(
        selected: index,
        onChanged: (i) {
          if (i == 0) {
            ttStore.loadTimeTrackerEntries();
          }
          setState(() => index = i);
        },
        header: Container(
            height: kOneLineTileHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Image.asset("assets/images/logo.png",
                    height: kOneLineTileHeight))),
        displayMode: appTheme.displayMode,
        indicatorBuilder: ({
          BuildContext context,
          int index,
          List<Offset> Function() offsets,
          List<Size> Function() sizes,
          Axis axis,
          Widget child,
        }) {
          if (index == null) return child;
          assert(debugCheckHasFluentTheme(context));
          final theme = NavigationPaneTheme.of(context);
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return EndNavigationIndicator(
                index: index,
                offsets: offsets,
                sizes: sizes,
                child: child,
                color: theme.highlightColor,
                curve: theme.animationCurve ?? Curves.linear,
                axis: axis,
              );
            case NavigationIndicators.sticky:
              return NavigationPane.defaultNavigationIndicator(
                index: index,
                context: context,
                offsets: offsets,
                sizes: sizes,
                axis: axis,
                child: child,
              );
            default:
              return NavigationIndicator(
                index: index,
                offsets: offsets,
                sizes: sizes,
                child: child,
                color: theme.highlightColor,
                curve: theme.animationCurve ?? Curves.linear,
                axis: axis,
              );
          }
        },
        items: [
          PaneItem(icon: Icon(Icons.input), title: Text('List of Entries')),
          PaneItem(icon: Icon(Icons.web_rounded), title: Text('Web version')),
        ],
        footerItems: [
          PaneItemSeparator(),
          PaneItem(icon: Icon(Icons.settings), title: Text('Settings')),
        ],
      ),
      content: NavigationBody(index: index, children: [
        Entries(),
        Web(),
        Settings(controller: settingsController),
      ]),
    );
  }
}
