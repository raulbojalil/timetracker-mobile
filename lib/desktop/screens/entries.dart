import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_mobile/desktop/timetracker_store.dart';

class Entries extends StatelessWidget {
  const Entries({Key key}) : super(key: key);

  shortenDescription(String description, [int length = 100]) {
    return description.length > length
        ? description.substring(0, length) + "..."
        : description;
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    final dateController = TextEditingController();
    final hoursController = TextEditingController();
    final descriptionController = TextEditingController();

    final ttStore = context.watch<TimeTrackerStore>();

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
                final ttDialogStore = dialogContext.watch<TimeTrackerStore>();
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
                              final success = await ttStore.addEntry(
                                  dateController.text,
                                  hoursController.text,
                                  descriptionController.text);

                              if (success) {
                                Navigator.pop(context);
                                ttStore.loadTimeTrackerTimes();
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
      content: ttStore.loading
          ? Center(
              child: Text("Loading..."),
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
                  for (var item in ttStore.list)
                    TappableListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 0x02, 0x72, 0xB1),
                        child: Text(item.date.split("/").elementAt(0)),
                      ),
                      title: Text(shortenDescription(item.description)),
                      subtitle: Text("${item.hours} hour(s) on ${item.date}"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ContentDialog(
                              title: Text('Entry details'),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.description),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Project: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(item.project),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Assignment Type: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(item.assignmentType),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Date: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(item.date),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Hours: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(item.hours),
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
            ),
    );
  }
}
