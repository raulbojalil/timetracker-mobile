import 'package:timetracker_mobile/mobile/settings/settings_input_widget.dart';
import 'package:timetracker_mobile/shared/providers/settings_provider.dart';
import 'package:timetracker_mobile/shared/providers/timetracker_provider.dart';
import 'package:timetracker_mobile/shared/setting_types.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({
    Key key,
  }) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsContent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _SettingsWidgetState();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: ListView(
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
              SettingsInputWidget(settings, "Username", SettingTypes.USERNAME),
              SettingsInputWidget(settings, "Password", SettingTypes.PASSWORD),
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
    );
  }
}
