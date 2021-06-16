import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_mobile/desktop/settings_store.dart';
import 'package:timetracker_mobile/desktop/theme.dart';

const List<String> accentColorNames = [
  'System',
  'Yellow',
  'Orange',
  'Red',
  'Magenta',
  'Purple',
  'Blue',
  'Teal',
  'Green',
];

class Settings extends StatelessWidget {
  Settings({Key key, this.controller}) : super(key: key);

  final ScrollController controller;

  final TextEditingController assignmentTypeIdController =
      new TextEditingController();
  final TextEditingController projectIdController = new TextEditingController();
  final TextEditingController focalPointIdController =
      new TextEditingController();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    final settings = context.watch<SettingsStore>();

    assignmentTypeIdController.text =
        settings.loadSetting(SettingTypes.ASSIGNMENT_TYPE_ID);
    projectIdController.text = settings.loadSetting(SettingTypes.PROJECT_ID);
    focalPointIdController.text =
        settings.loadSetting(SettingTypes.FOCAL_POINT_ID);
    usernameController.text = settings.loadSetting(SettingTypes.USERNAME);
    passwordController.text = settings.loadSetting(SettingTypes.PASSWORD);

    final tooltipThemeData = TooltipThemeData(decoration: () {
      final radius = BorderRadius.zero;
      final shadow = [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(1, 1),
          blurRadius: 10.0,
        ),
      ];
      final border = Border.all(color: Colors.grey[100], width: 0.5);
      if (FluentTheme.of(context).brightness == Brightness.light) {
        return BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: border,
          boxShadow: shadow,
        );
      } else {
        return BoxDecoration(
          color: Colors.grey,
          borderRadius: radius,
          border: border,
          boxShadow: shadow,
        );
      }
    }());
    return ScaffoldPage(
      header: PageHeader(title: Text('Settings')),
      content: ListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        controller: controller,
        children: [
          Text('Secrets', style: FluentTheme.of(context).typography.subtitle),
          TextBox(
              onChanged: (value) {
                settings.saveSetting(SettingTypes.USERNAME, value);
              },
              controller: usernameController,
              header: "Username"),
          TextBox(
            onChanged: (value) {
              settings.saveSetting(SettingTypes.PASSWORD, value);
            },
            keyboardType: TextInputType.visiblePassword,
            controller: passwordController,
            header: "Password",
          ),
          TextBox(
            onChanged: (value) {
              settings.saveSetting(SettingTypes.ASSIGNMENT_TYPE_ID, value);
            },
            controller: assignmentTypeIdController,
            header: "Assignment Type ID",
            placeholder:
                "To get this value, go to the TT web site and inspect the 'Assignment type' <select/>. Then, get the value of the desired <option/>.",
          ),
          TextBox(
            header: "Project ID",
            controller: projectIdController,
            onChanged: (value) {
              settings.saveSetting(SettingTypes.PROJECT_ID, value);
            },
            placeholder:
                "To get this value, go to the TT web site and inspect the 'Project' <select/>. Then, get the value of the desired <option/>.",
          ),
          TextBox(
            header: "Focal Point ID",
            controller: focalPointIdController,
            onChanged: (value) {
              settings.saveSetting(SettingTypes.FOCAL_POINT_ID, value);
            },
            placeholder:
                "To get this value, go to the TT web site and inspect the 'Client Focal Point' <select/>. Then, get the value of the desired <option/>.",
          ),
          Text('Theme mode',
              style: FluentTheme.of(context).typography.subtitle),
          ...List.generate(ThemeMode.values.length, (index) {
            final mode = ThemeMode.values[index];
            return RadioListTile(
              checked: appTheme.mode == mode,
              onChanged: (value) {
                if (value) {
                  appTheme.mode = mode;
                }
              },
              title: Text(
                '$mode'.replaceAll('ThemeMode.', ''),
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            );
          }),
          Text(
            'Navigation Pane Display Mode',
            style: FluentTheme.of(context).typography.subtitle,
          ),
          ...List.generate(PaneDisplayMode.values.length, (index) {
            final mode = PaneDisplayMode.values[index];
            return RadioListTile(
              checked: appTheme.displayMode == mode,
              onChanged: (value) {
                if (value) appTheme.displayMode = mode;
              },
              title: Text(
                mode.toString().replaceAll('PaneDisplayMode.', ''),
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            );
          }),
          Text('Navigation Indicator',
              style: FluentTheme.of(context).typography.subtitle),
          ...List.generate(NavigationIndicators.values.length, (index) {
            final mode = NavigationIndicators.values[index];
            return RadioListTile(
              checked: appTheme.indicator == mode,
              onChanged: (value) {
                if (value) appTheme.indicator = mode;
              },
              title: Text(
                mode.toString().replaceAll('NavigationIndicators.', ''),
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            );
          }),
          Text('Accent Color',
              style: FluentTheme.of(context).typography.subtitle),
          Wrap(children: [
            Tooltip(
              style: tooltipThemeData,
              child: _buildColorBlock(appTheme, systemAccentColor),
              message: accentColorNames[0],
            ),
            ...List.generate(Colors.accentColors.length, (index) {
              final color = Colors.accentColors[index];
              return Tooltip(
                style: tooltipThemeData,
                message: accentColorNames[index + 1],
                child: _buildColorBlock(appTheme, color),
              );
            }),
          ]),
        ],
      ),
    );
  }

  Widget _buildColorBlock(AppTheme appTheme, AccentColor color) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Button(
        onPressed: () {
          appTheme.color = color;
        },
        style: ButtonStyle(
          padding: ButtonState.all(EdgeInsets.zero),
        ),
        child: Container(
          height: 40,
          width: 40,
          color: color,
          alignment: Alignment.center,
          child: appTheme.color == color
              ? Icon(Icons.check, color: color.basedOnLuminance())
              : null,
        ),
      ),
    );
  }
}
