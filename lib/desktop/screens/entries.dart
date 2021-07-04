import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_mobile/shared/models/timetrackerentry.dart';
import 'package:timetracker_mobile/shared/providers/timetracker_provider.dart';

class Entries extends StatelessWidget {
  const Entries({Key key}) : super(key: key);

  shortenDescription(String description, [int length = 100]) {
    return description.length > length
        ? description.substring(0, length) + "..."
        : description;
  }

  areHoursComplete(TimeTrackerEntry entry, List<TimeTrackerEntry> entries) {
    double totalHours = 0;
    entries.where((element) => element.date == entry.date).forEach((element) {
      totalHours += element.hours;
    });

    //Change this if you work more (or less) hours
    return totalHours == 8;
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    final dateController = TextEditingController();
    final hoursController = TextEditingController();
    final descriptionController = TextEditingController();

    final timeTracker = context.watch<TimeTrackerProvider>();

    return ScaffoldPage(
      header: PageHeader(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Time Tracker Entries'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            dateController.text =
                DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
            showDialog(
              context: context,
              builder: (dialogContext) {
                final ttDialogStore =
                    dialogContext.watch<TimeTrackerProvider>();
                return ContentDialog(
                  backgroundDismiss: true,
                  title: Text('Add new entry'),
                  content: Column(
                    children: [
                      TextBox(
                        keyboardType: TextInputType.datetime,
                        controller: dateController,
                        header: 'Date',
                        placeholder: '',
                      ),
                      TextBox(
                        keyboardType: TextInputType.number,
                        controller: hoursController,
                        header: 'Hours',
                        placeholder: '',
                      ),
                      TextBox(
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        controller: descriptionController,
                        header: 'Description',
                        placeholder: '',
                        minHeight: 100,
                      ),
                    ],
                  ),
                  actions: [
                    ttDialogStore.saving
                        ? Button(child: Text("Saving..."), onPressed: null)
                        : Button(
                            onPressed: () async {
                              final success = await timeTracker.addEntry(
                                  dateController.text,
                                  hoursController.text,
                                  descriptionController.text);

                              if (success) {
                                Navigator.pop(context);
                                timeTracker.loadTimeTrackerEntries();
                              }
                            },
                            child: Text("OK"),
                          ),
                    ttDialogStore.saving
                        ? Button(child: Text("Cancel"), onPressed: null)
                        : Button(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          )
                  ],
                );
              },
            );
          },
        ),
      ])),
      content: timeTracker.loading
          ? Center(
              child: Text("Loading..."),
            )
          : (timeTracker.missingData
              ? Center(
                  child: Text(
                      "Please go to the Settings page to fill in the missing data required to fetch the time tracker entries"),
                )
              : (timeTracker.list.length == 0
                  ? Center(
                      child: Text(
                          "No items found. Add your first item by using the + button."),
                    )
                  : ListView(
                      padding: EdgeInsets.only(
                        bottom: kPageDefaultVerticalPadding,
                        left: PageHeader.horizontalPadding(context),
                        right: PageHeader.horizontalPadding(context),
                      ),
                      controller: scrollController,
                      children: [
                        Wrap(children: [
                          for (var item in timeTracker.list)
                            TappableListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    areHoursComplete(item, timeTracker.list)
                                        ? Color.fromARGB(255, 0x02, 0x72, 0xB1)
                                        : Color.fromARGB(255, 255, 0, 0),
                                child: Text(item.date.split("/").elementAt(0)),
                              ),
                              title: Text(shortenDescription(item.description)),
                              subtitle:
                                  Text("${item.hours} hour(s) on ${item.date}"),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ContentDialog(
                                      title: Text('Entry details'),
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.description),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Row(
                                              children: [
                                                Text("Project: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(item.project),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Row(
                                              children: [
                                                Text("Assignment Type: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(item.assignmentType),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Row(
                                              children: [
                                                Text("Date: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(item.date),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Row(
                                              children: [
                                                Text("Hours: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(item.hours.toString()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        Button(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Close"),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                        ]),
                      ],
                    ))),
    );
  }
}
