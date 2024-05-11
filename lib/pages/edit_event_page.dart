import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/pages/user_event_creation_page.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Define a stateful widget for event edit that is mutable and its corresponding state class.
class EventEditPage extends StatefulWidget {
  final Event event; // Event that we are editing.s
  final VoidCallback refreshParent;
  const EventEditPage(
      {super.key, required this.event, required this.refreshParent});

  @override
  EventEditPageState createState() => EventEditPageState();
}

/// This is the state class to manage mutable state data and the widget's lifecycle for event edit page.
class EventEditPageState extends State<EventEditPage> {
  late final TextEditingController _title;
  late final TextEditingController _location;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late final TextEditingController _description;
  late bool? _studentsOnly;
  late List<String>? _tagsList;
  late String? _tagsString;
  late String? _repeat;
  late final TextEditingController _repeatDate;
  late final int _id;
  late final Event _event;

  /// initState function initializes all of the late final variables from above.
  // Initialize based on the event information that we got.
  @override
  void initState() {
    _title = TextEditingController(text: _event.title);
    _location = TextEditingController(text: _event.location);
    _startDate = TextEditingController(text: _event.start);
    _endDate = TextEditingController(text: _event.end);
    _description = TextEditingController(text: _event.description);
    _studentsOnly = _event.studentsOnly;
    _tagsList = _event.tags;
    _tagsString = "";
    _id = _event.id;
    _repeatDate = TextEditingController();
    _repeat = "";
    _event = widget.event;
    super.initState();
  } // initState

  /// dispose function cleans up tasks.
  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _description.dispose();
    _startDate.dispose();
    _endDate.dispose();
    _repeatDate.dispose();
    _repeat = null;
    _studentsOnly = null;
    _tagsList = [];
    _tagsString = "";
    _repeat = "";
    super.dispose();
  } // dispose

  // selectDateTime function allows users to select date and time for their events
  // in the built-in date and time widgets of Flutter.
  Future<void> selectDateTime(
      BuildContext context, TextEditingController control) async {
    // Show date picker to user with limited range.
    final DateTime? userDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(), // Earliest allowed date is the current date.
        lastDate: DateTime(2500) // Latest allowed date is the year of 2500.
        ); // userDate

    // If the user inputted a date, do this:
    if (userDate != null) {
      // Get the time.
      // Show time picker to user with limited range.
      final TimeOfDay? userTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now() // Initial time will be the current time.
          ); // userTime

      // If the user inputted a time, do this:
      if (userTime != null) {
        // Create full date-time format.
        final DateTime userDateTime = DateTime(userDate.year, userDate.month,
            userDate.day, userTime.hour, userTime.minute); // userDateTime

        // Save date-time to the controller's text as a string.
        setState(() {
          control.text = userDateTime.toString();
        });
      }
    }
  } // selectDateTime

  /// showMultiSelect function allows users to multiselect event tags.
  void showMultiSelect() async {
    // This is the list of event tags.
    final List<String> items = ALLTAGS;

    // Allow users to choose tags.
    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(elements: items);
        });

    // Update UI.
    if (results != null) {
      setState(() {
        _tagsList = results;
      });
    }

    // Update variable to send tags to backend; create a comma-separated string.
    _tagsString = _tagsList?.join(';');
  } // showMultiSelect

  /// Build UI of widget.
// Everything is wrapped in a container with child content being scrollable.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            foregroundColor: Colors.white,
            title: const Text('Edit Event',
                style: TextStyle(fontWeight: FontWeight.w800)),
            backgroundColor: Theme.of(context).colorScheme.primary),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    // Arrange children vertically.
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // EVENT TITLE BOX DISPLAYS HERE.
                      TextField(
                        controller: _title,
                        autocorrect: false,
                        enableSuggestions: false,
                        maxLines: null,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.create),
                            labelText: 'Event Title',
                            hintText: 'Enter the title of your event',
                            border: OutlineInputBorder()),
                      ),

                      const SizedBox(
                          height:
                              10), // This is the gap in between text fields.

                      // EVENT LOCATION BOX DISPLAYS HERE.
                      TextField(
                        controller: _location,
                        autocorrect: false,
                        enableSuggestions: false,
                        maxLines: null,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.location_on_outlined),
                            labelText: 'Location',
                            hintText: 'Enter the location of your event',
                            border: OutlineInputBorder()),
                      ),

                      const SizedBox(height: 10),

                      // EVENT START TIME BOX DISPLAYS HERE.
                      TextField(
                        controller: _startDate,
                        readOnly: true, // Don't ask for text keyboard input
                        onTap: () => selectDateTime(context, _startDate),
                        decoration: const InputDecoration(
                            icon: Icon(Icons.access_time),
                            labelText: 'Event Starts...',
                            hintText:
                                'Pick the starting date & time of your event',
                            border: OutlineInputBorder()),
                      ),

                      const SizedBox(height: 10),

                      // EVENT END TIME BOX DISPLAYS HERE.
                      TextField(
                        controller: _endDate,
                        readOnly: true,
                        onTap: () => selectDateTime(context, _endDate),
                        decoration: const InputDecoration(
                            icon: Icon(Icons.access_time_filled),
                            labelText: 'Event Ends...',
                            hintText:
                                'Pick the ending date & time of your event',
                            border: OutlineInputBorder()),
                      ),

                      const SizedBox(height: 10),

                      // EVENT DESCRIPTION BOX DISPLAYS HERE.
                      TextField(
                        controller: _description,
                        autocorrect: false,
                        enableSuggestions: false,
                        maxLines: null,
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter a description of your event',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            icon: Icon(Icons.summarize_outlined)),
                      ),

                      const SizedBox(height: 10),

                      // STUDENTS ONLY TAG CHECKBOX DISPLAYS HERE.
                      CheckboxListTile(
                        title: const Text("Student-Only Event?"),
                        value: _studentsOnly,
                        onChanged: (newValue) {
                          setState(() {
                            _studentsOnly = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      const SizedBox(height: 10),

                      // EVENT TAGS BUTTON DISPLAYS HERE.
                      ElevatedButton(
                          onPressed: showMultiSelect,
                          child: const Text('Select your Event Type')),

                      const SizedBox(height: 10),

                      // DISPLAY CHOSEN EVENT TAGS.
                      Wrap(
                        children: _tagsList!
                            .map((e) => Chip(
                                  label: Text(e),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 10),

                      // EDIT EVENT BUTTON SENDS UPDATED INFORMATIONN TO BACKEND.
                      SizedBox(
                          width: double.infinity, // Span the whole screen.
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 143, 28),
                                  foregroundColor: Colors.black),
                              // When the button is pressed, do this:
                              onPressed: () async {
                                // Send event information to backend.
                                // Send to Edit Event URL.
                                var create = await eventInfo(
                                    _title.text,
                                    _location.text,
                                    _startDate.text,
                                    _endDate.text,
                                    _description.text,
                                    _repeat,
                                    _repeatDate.text,
                                    _studentsOnly,
                                    _tagsString,
                                    null,
                                    _id,
                                    'https://grinsync.com/api/editEvent');

                                if (create.runtimeType == String) {
                                  // Show error messages from the backend.
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Event Edit Error'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('$create'),
                                              const Text(
                                                  'Please edit event details.')
                                            ],
                                          ),
                                        ),

                                        // Allow user to exit out of error message.
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Okay'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                                // Otherwise, event information was successfully sent to backend
                                // Give success message.
                                else {
                                  Fluttertoast.showToast(
                                      msg: 'Event Edited Successfully!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey[300],
                                      textColor: Colors.black,
                                      fontSize: 16.0);

                                  // Refresh the parent page
                                  widget.refreshParent();

                                  // Go back to the previous page
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Edit Event') // Button title.
                              ))
                    ]))));
  } // build
} // EventCreationPageState
