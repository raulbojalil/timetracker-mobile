import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timetracker_mobile/shared/const.dart';
import 'package:timetracker_mobile/shared/timetracker.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

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
  bool isLoading = false;
  bool errorOccurred = false;
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

  Future<bool> addNewEntry() async {
    setState(() {
      errorOccurred = false;
      isLoading = true;
    });

    try {
      await TimeTracker.login(Constants.USERNAME, Constants.PASSWORD);

      await TimeTracker.cargaTimeTracker(
          dateController.text,
          Constants.PROJECT_ID,
          hoursController.text,
          Constants.ASSIGNMENT_TYPE_ID,
          descriptionController.text,
          Constants.FOCAL_POINT_ID);

      return true;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error occurred, please try again later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        errorOccurred = true;
      });
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;

    Function callback;

    if (arguments != null) {
      callback = arguments['callback'];
    }

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: Lottie.asset('assets/lottie/9965-loading-spinner.json'))
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
                            final success = await addNewEntry();

                            if (!success) {
                              return;
                            }

                            Navigator.pop(context);

                            if (callback != null) {
                              callback();
                            }
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
