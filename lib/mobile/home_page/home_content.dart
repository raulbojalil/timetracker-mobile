import 'package:flutter/material.dart';
import 'package:timetracker_mobile/mobile/flutter_flow/flutter_flow_theme.dart';
import 'package:timetracker_mobile/shared/providers/timetracker_provider.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatefulWidget {
  static const String routeName = '/';

  const HomeContent({
    Key key,
  }) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTrackerProvider>();
    return Scaffold(
      floatingActionButton: Stack(children: [
        Positioned(
            bottom: 50,
            right: 0,
            child: FloatingActionButton(
              tooltip: "Add new entry",
              onPressed: () async {
                await Navigator.pushNamed(context, '/addnewentry');
              },
              backgroundColor: FlutterFlowTheme.primaryColor,
              elevation: 8,
              child: Icon(
                Icons.add,
                color: Color(0xFFFFEBEE),
                size: 24,
              ),
            ))
      ]),
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.primaryColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Image.asset(
                      'assets/images/logo_white.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.primaryColor,
                      ),
                      child: Align(
                        alignment: Alignment(0, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            'TIME TRACKER',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Poppins',
                              color: Color(0xFFFAFAFA),
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            timeTracker.loading
                ? Expanded(child: Center(child: Text("Loading...")))
                : (timeTracker.missingData
                    ? Expanded(
                        child: Center(
                            child: Text(
                                "Go to the Settings page (top right) to configure your secrets")))
                    : Expanded(
                        child: timeTracker.list.length == 0
                            ? Center(child: Text("No data"))
                            : ListView.separated(
                                itemCount: timeTracker.list.length,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(
                                          height: 0,
                                        ),
                                itemBuilder: (BuildContext context, int index) {
                                  final item = timeTracker.list[index];
                                  return ListTile(
                                    title: Text(
                                      item.description,
                                      style: FlutterFlowTheme.title3.override(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${item.hours} hour(s) on ${item.date}",
                                      style:
                                          FlutterFlowTheme.subtitle2.override(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    tileColor: Color(0xFFF5F5F5),
                                    dense: false,
                                  );
                                }),
                      ))
          ],
        ),
      ),
    );
  }
}
