import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/main.dart';

// TODO: NO SAVE DRAFT OPTION; IF USERS EXIT THE CREATE EVENT PAGE ALL THEIR INPUT IS LOST

// Define a stateful widget for event creation that is mutable and its corresponding state class
class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});
  @override
  State<EventCreationPage> createState() => EventCreationPageState();
}

// Define a stateful widget for multiselect option for event tags.
class MultiSelect extends StatefulWidget {
  final List<String> elements;
  const MultiSelect({super.key, required this.elements});
  @override
  State<MultiSelect> createState() => MultiSelectState();
}

// State class to manage multiselect
class MultiSelectState extends State<MultiSelect> {
  // List to hold selected items
  final List<String> selectedItems = [];

  // Function called when item is selected or unselected
  void itemChange(String item, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    });
  }

  // Function called when the cancel button is hit
  void cancel() {
    Navigator.pop(context);
  }

  // Function called when the submit button is hit
  void submit() {
    Navigator.pop(context, selectedItems);
  }

  // Pop-up window to allow user to select event tags
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Select Event Tags'),
        content: SingleChildScrollView(
          child: ListBody(
            children: widget.elements
                .map((item) => CheckboxListTile(
                    value: selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => itemChange(item, isChecked!)))
                .toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: cancel, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: submit,
            child: const Text('Submit'),
          )
        ]);
  }
} // MultiSelectState

// State class to manage mutable state data and the widget's lifecycle for event creation page
class EventCreationPageState extends State<EventCreationPage> {
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
  late List<String> _tags;
  late String _tagsString;
  late String? _repeat;

  // initState function to initialize all of the late final variables from above
  @override
  void initState() {
    // _orgId = TextEditingController(); TODO: Uncomment when we implement student orgs
    _title = TextEditingController();
    _location = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
    _description = TextEditingController();
    _studentsOnly = false;
    _tags = [];
    _tagsString = "";
    _repeat = null;
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
      // Show time picker to user with limited range
      final TimeOfDay? userTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now() // Initial time will be the current time
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
  } // selectDateTime

  // showMultiSelect function to allow users to multiselect event tags
  void showMultiSelect() async {
    final List<String> items = [
      'Fee Required',
      'Food/Drinks Provided',
      'Grinnell Athletics',
      'Student Org',
      'Admin Hosted',
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

    // Update variable to send tags to backend
    _tagsString = _tags.join(',');
  } // showMultiSelect

// Build UI of widget
// Everything is wrapped in a container with child content being scrollable
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      const Text('Repeats:'),

                      DropdownButton(
                        hint: const Text('Select Repeating Event Customization'),
                        items: const [
                          DropdownMenuItem(value: "None", child: Text("None")),
                          DropdownMenuItem(value: "Daily", child: Text("Daily")),
                          DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
                          DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                        ], 
                        isExpanded: true,
                        value: _repeat,
                        onChanged: (newValue) {
                          setState(() {
                            _repeat = newValue;
                          });
                        }
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
                      // TODO: Make it so that the event tags are saved every time they press the button
                      Wrap(
                        children: _tags
                            .map((e) => Chip(
                                  label: Text(e),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 10),

                      // CREATE EVENT BUTTON - SEND INFO TO BACKEND
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
                                    _studentsOnly,
                                    _tagsString);

                                // When the event info did not successfully go to the backend
                                if (create.runtimeType == String) {
                                  // Show error message
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Event Creation Error'),
                                        content: const SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'GrinSync could not create your event.'),
                                              Text('Please try again.')
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
                                } else if (create.runtimeType == int) {
                                  // Show error message
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Event Creation Error'),
                                        content: const SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Event is missing information/has invalid input.'),
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

                                // Otherwise, event info was successfully sent to backend
                                else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp()),
                                  );
                                }
                              },
                              child: const Text('Create Event') // Button title
                              ))
                    ]))));
  } // build
} // EventCreationPageState
