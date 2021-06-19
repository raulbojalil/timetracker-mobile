import 'package:timetracker_mobile/shared/notifications.dart';
import 'package:timetracker_mobile/shared/providers/timetracker_provider.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  static const String routeName = '/';

  const HomePageWidget(
    this.notificationAppLaunchDetails, {
    Key key,
  }) : super(key: key);

  final NotificationAppLaunchDetails notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Future<void> _showNotification() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //           'your channel id', 'your channel name', 'your channel description',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           ticker: 'ticker');
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'plain title', 'plain body', platformChannelSpecifics,
  //       payload: 'item x');
  // }

  Future<void> _scheduleDailyFivePMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time Tracker',
        'Please upload your hours',
        _nextInstanceOfFivePM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfFivePM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 17);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {});
  }

  void loadNewEntryPage() async {
    await Navigator.pushNamed(context, '/addnewentry');
  }

  void loadSettingsPage() async {
    await Navigator.pushNamed(context, '/settings');
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      loadNewEntryPage();
    });
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    _scheduleDailyFivePMNotification();
  }

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTrackerProvider>();
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          loadNewEntryPage();
        },
        backgroundColor: FlutterFlowTheme.primaryColor,
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Color(0xFFFFEBEE),
          size: 24,
        ),
      ),
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
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.menu, color: Color(0xFFFAFAFA)),
                    onSelected: (value) {
                      loadSettingsPage();
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Settings'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
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
