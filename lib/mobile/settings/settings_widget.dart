import 'package:timetracker_mobile/mobile/settings/settings_input_widget.dart';
import 'package:timetracker_mobile/shared/providers/settings_provider.dart';
import 'package:timetracker_mobile/shared/providers/timetracker_provider.dart';
import 'package:timetracker_mobile/shared/setting_types.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    Key key,
  }) : super(key: key);

  static const String routeName = '/settings';

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _SettingsWidgetState();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final timeTracker = context.watch<TimeTrackerProvider>();

    return new WillPopScope(
        onWillPop: () async {
          timeTracker.loadTimeTrackerEntries();
          return true;
        },
        child: Scaffold(
          key: scaffoldKey,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 1),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Settings',
                        style: FlutterFlowTheme.bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: FlutterFlowTheme.primaryColor,
                    thickness: 2,
                  ),
                  SettingsInputWidget(
                      settings, "Username", SettingTypes.USERNAME),
                  SettingsInputWidget(
                      settings, "Password", SettingTypes.PASSWORD),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "You can get the following by going to the Time Tracker website and inspecting the <select/> controls in the CargaTimeTracker.aspx page")),
                  SettingsInputWidget(settings, "Assignment Type ID",
                      SettingTypes.ASSIGNMENT_TYPE_ID),
                  SettingsInputWidget(
                      settings, "Project ID", SettingTypes.PROJECT_ID),
                  SettingsInputWidget(
                      settings, "Focal Point ID", SettingTypes.FOCAL_POINT_ID),
                ],
              ),
            ),
          ),
        ));
  }
}
