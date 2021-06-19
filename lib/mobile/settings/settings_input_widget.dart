import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timetracker_mobile/mobile/flutter_flow/flutter_flow_theme.dart';
import 'package:timetracker_mobile/shared/providers/settings_provider.dart';

class SettingsInputWidget extends StatelessWidget {
  final SettingsProvider settings;
  final String labelText;
  final String settingName;

  const SettingsInputWidget(this.settings, this.labelText, this.settingName,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        initialValue: settings.loadSetting(this.settingName),
        onChanged: (value) {
          settings.saveSetting(settingName, value);
        },
        obscureText: false,
        decoration: InputDecoration(
          labelText: this.labelText,
          labelStyle: FlutterFlowTheme.bodyText1.override(
            fontFamily: 'Poppins',
          ),
          hintStyle: FlutterFlowTheme.bodyText1.override(
            fontFamily: 'Poppins',
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          filled: true,
        ),
        style: FlutterFlowTheme.bodyText1.override(
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
