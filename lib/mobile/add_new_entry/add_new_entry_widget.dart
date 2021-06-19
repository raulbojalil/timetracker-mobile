import 'dart:io';

import 'package:flutter/services.dart';
import 'package:timetracker_mobile/shared/providers/timetracker_provider.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddNewEntryWidget extends StatefulWidget {
  const AddNewEntryWidget(
    this.payload, {
    Key key,
  }) : super(key: key);

  final String payload;

  static const String routeName = '/addnewentry';

  @override
  _AddNewEntryWidgetState createState() => _AddNewEntryWidgetState();
}

class _AddNewEntryWidgetState extends State<AddNewEntryWidget> {
  TextEditingController dateController;
  TextEditingController hoursController;
  TextEditingController descriptionController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _AddNewEntryWidgetState();

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    dateController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    hoursController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final timeTracker = context.watch<TimeTrackerProvider>();

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: timeTracker.saving
            ? Center(child: Text("Saving, please wait..."))
            : Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 1),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add new entry',
                          style: FlutterFlowTheme.bodyText1.override(
                            fontFamily: 'Poppins',
                            fontSize: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final success = await timeTracker.addEntry(
                                dateController.text,
                                hoursController.text,
                                descriptionController.text);

                            if (!success) {
                              return;
                            }

                            timeTracker.loadTimeTrackerEntries();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.check,
                            color: Color(0xFF303030),
                            size: 35,
                          ),
                          iconSize: 35,
                        )
                      ],
                    ),
                    Divider(
                      color: FlutterFlowTheme.primaryColor,
                      thickness: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: TextFormField(
                        controller: dateController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Date',
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
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100));

                          if (date != null)
                            dateController.text = DateFormat('dd/MM/yyyy')
                                .format(date)
                                .toString();
                        },
                        style: FlutterFlowTheme.bodyText1.override(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: TextFormField(
                        controller: hoursController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Hours',
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
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: TextFormField(
                        controller: descriptionController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Description',
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
                        maxLines: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
