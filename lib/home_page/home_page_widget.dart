import '../add_new_page/add_new_page_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewPageWidget(),
            ),
          );
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
                      'assets/images/logo.png',
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
            // Expanded(
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     scrollDirection: Axis.vertical,
            //     children: [
            //       ListTile(
            //         title: Text(
            //           'Lorem ipsum dolor...',
            //           style: FlutterFlowTheme.title3.override(
            //             fontFamily: 'Poppins',
            //           ),
            //         ),
            //         subtitle: Text(
            //           'Lorem ipsum dolor...',
            //           style: FlutterFlowTheme.subtitle2.override(
            //             fontFamily: 'Poppins',
            //           ),
            //         ),
            //         tileColor: Color(0xFFF5F5F5),
            //         dense: false,
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
