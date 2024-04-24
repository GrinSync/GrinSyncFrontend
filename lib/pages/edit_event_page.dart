import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/pages/user_event_creation_page.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Define a stateful widget for event edit that is mutable and its corresponding state class
class EventEditPage extends StatefulWidget {
  final Event event; // Event that we are editing
  const EventEditPage({super.key, required this.event});

  @override
  EventEditPageState createState() => EventEditPageState();
}

// State class to manage mutable state data and the widget's lifecycle for event edit page
class EventEditPageState extends State<EventEditPage> {
  // late = initialization occurs later in the code
  // final = variable can only be assigned to a value once
  // TextEditingController = class that allows for the manipulation of text input
  // late final TextEditingController _orgId; TODO: Uncomment when we implement student orgs
  late final TextEditingController _title;
  late final TextEditingController _location;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late final TextEditingController _description;
  late bool? _studentsOnly;
  late List<String>? _tags;
  late String?
      _tagsString; // Convert the list above to a comma-separated string
  late String? _repeat;
  late final TextEditingController _repeatDate;
  late final int _id;
  late final Event event = widget.event;

  // initState function to initialize all of the late final variables from above
  // Initialize based on the event information that we got
  @override
  void initState() {
    // _orgId = TextEditingController(); TODO: Uncomment when we implement student orgs
    _title = TextEditingController(text: event.title);
    _location = TextEditingController(text: event.location);
    _startDate = TextEditingController(text: event.start);
    _endDate = TextEditingController(text: event.end);
    _description = TextEditingController(text: event.description);
    _studentsOnly = event.studentsOnly;
    _tagsString = event.tags;
    if (_tagsString != "") {
      _tags = _tagsString?.split(",");
    } else {
      _tags = [];
    }
    _repeat = null; // TODO WHEN EVENT MODEL IS UPDATED
    _repeatDate = TextEditingController(); // TODO WHEN EVENT MODEL IS UPDATED
    _id = event.id;
    super.initState();
  } // initState

  // dispose function for cleanup tasks
  @override
  void dispose() {
    // _orgId.dispose(); TODO: Uncomment when we implement student orgs
    _title.dispose();
    _location.dispose();
    _description.dispose();
    _startDate.dispose();
    _endDate.dispose();
    _repeatDate.dispose();
    _studentsOnly = null;
    _tags = [];
    _tagsString = "";
    _repeat = "";
    super.dispose();
  } // dispose

  // selectDateTime function to allow users to select date and time for their events
  // in the built-in date and time widgets of Flutter
  Future<void> selectDateTime(
      BuildContext context, TextEditingController control) async {
    // Show date picker to user with limited range
    final DateTime? userDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(), // Earliest allowed date is the current date
        lastDate: DateTime(2500) // Latest allowed date is the year of 2500
        ); // userDate

    // If the user inputted a date, do this:
    if (userDate != null) {
      // If this is for the repeat end date, we only want the date. So we have the date and we save date to the controller's text as a string
      if (control == _repeatDate) {
        final DateTime userRepeatDate =
            DateTime(userDate.year, userDate.month, userDate.day);
        setState(() {
          control.text = userRepeatDate.toString();
        });
      }

      // Otherwise, get the time
      else {
        // Show time picker to user with limited range
        final TimeOfDay? userTime = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay.now() // Initial time will be the current time
            ); // userTime

        // If the user inputted a time, do this:
        if (userTime != null) {
          // Create full date-time format
          final DateTime userDateTime = DateTime(userDate.year, userDate.month,
              userDate.day, userTime.hour, userTime.minute); // userDateTime

          // Save date-time to the controller's text as a string
          setState(() {
            control.text = userDateTime.toString();
          });
        }
      }
    }
  } // selectDateTime

  // showMultiSelect function to allow users to multiselect event tags
  void showMultiSelect() async {
    // List of event tags
    final List<String> items = [
      'Fee Required',
      'RSVP Required',
      'Food/Drinks Provided',
      'Athletic',
      'Cultural',
      'Academic',
      'Study Break',
      'Hosted by SEPCs',
      'Hosted by Student Orgs',
      'Hosted by CAs',
      'Hosted by Admin',
      'Off Campus'
    ];

    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(elements: items);
        });

    // Update UI
    if (results != null) {
      setState(() {
        _tags = results;
      });
    }

    // Update variable to send tags to backend; create a comma-separated string
    _tagsString = _tags?.join(',');
  } // showMultiSelect

// Build UI of widget
// Everything is wrapped in a container with child content being scrollable
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
                    // Arrange children vertically
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // EVENT TITLE BOX
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

                      const SizedBox(height: 10), // Gap in between text fields

                      // EVENT LOCATION BOX
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

                      // EVENT START TIME BOX
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

                      // EVENT END TIME BOX
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

                      // EVENT DESCRIPTION BOX
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

                      // REPEATING EVENT OPTIONS
                      const Text('How Often Does Your Event Repeat?:'),

                      DropdownButton(
                          hint: const Text(
                              'Select Repeating Event Customization'),
                          items: const [
                            DropdownMenuItem(
                                value: "None", child: Text("None")),
                            DropdownMenuItem(
                                value: "Daily", child: Text("Daily")),
                            DropdownMenuItem(
                                value: "Weekly", child: Text("Weekly")),
                            DropdownMenuItem(
                                value: "Monthly", child: Text("Monthly")),
                          ],
                          isExpanded: true,
                          value: _repeat,
                          onChanged: (newValue) {
                            setState(() {
                              _repeat = newValue;
                            });
                          }),

                      const SizedBox(height: 10),

                      // END REPEAT DATE
                      TextField(
                        controller: _repeatDate,
                        readOnly: true,
                        onTap: () => selectDateTime(context, _repeatDate),
                        decoration: const InputDecoration(
                            labelText: 'End Repeat...',
                            hintText:
                                'Pick the ending date for your repeating events',
                            border: OutlineInputBorder()),
                      ),

                      const SizedBox(height: 10),

                      // STUDENTS ONLY TAG CHECKBOX
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

                      // EVENT TAGS
                      ElevatedButton(
                          onPressed: showMultiSelect,
                          child: const Text('Select your Event Type')),

                      const SizedBox(height: 10),

                      // DISPLAY CHOSEN EVENT TAGS

                      Wrap(
                        children: _tags!
                            .map((e) => Chip(
                                  label: Text(e),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 10),

                      // EDIT EVENT BUTTON - SEND INFO TO BACKEND
                      SizedBox(
                          width: double.infinity, // Span the whole screen
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 143, 28),
                                  foregroundColor: Colors.black),
                              // When the button is pressed, do this:
                              onPressed: () async {
                                // Send event info to backend
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
                                    _id,
                                    'https://grinsync.com/api/editEvent');

                                if (create.runtimeType == String) {
                                  // Show error message - INVALID INPUT OR MISSING INFO
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Event Edit Error'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('$create'),
                                              Text('Please edit event details.')
                                            ],
                                          ),
                                        ),

                                        // Allow user to exit out of error message
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

                                // Otherwise, event info was successfully sent to backend; reload page
                                else {
                                  Fluttertoast.showToast(
                                      msg: 'Event Edited Successfully!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey[300],
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                }
                              },
                              child: const Text('Edit Event') // Button title
                              ))
                    ]))));
  } // build
} // EventCreationPageState
