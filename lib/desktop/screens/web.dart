import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_mobile/desktop/theme.dart';
import 'package:url_launcher/url_launcher.dart';

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

class Web extends StatelessWidget {
  const Web({Key key, this.controller}) : super(key: key);

  final ScrollController controller;

  Future launchURL(String url) async {
    var uri = Uri.parse(url).toString();
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();

    return ScaffoldPage(
        header: PageHeader(title: Text('Go to the web version')),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.all(30),
                child: Text("Click the button below to go to the web version")),
            Padding(
                padding: EdgeInsets.all(30),
                child: Button(
                  child: Text("Go to the web version"),
                  onPressed: () {
                    launchURL("https://timetracker.bairesdev.com/");
                  },
                ))
          ],
        ));
  }
}
