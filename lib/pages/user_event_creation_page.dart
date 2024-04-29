import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_student_orgs.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

// TODO: NO SAVE DRAFT OPTION; IF USERS EXIT THE CREATE EVENT PAGE ALL THEIR INPUT IS LOST

///// ----- MULTI-SELECT CLASS FOR MULTI-SELECTING EVENT TAGS ----- /////

// Define a stateful widget for multiselect option for event tags.
class MultiSelect extends StatefulWidget {
  final List<String> elements;
  const MultiSelect({super.key, required this.elements});
  @override
  State<MultiSelect> createState() => MultiSelectState();
}

// This is the state class to manage multiselect.
class MultiSelectState extends State<MultiSelect> {
  // Here is the list to hold selected items.
  final List<String> selectedItems = [];

  // This function is called when item is selected or unselected. 
  void itemChange(String item, bool isSelected) {
    setState(() {
      if (isSelected) {
        // Add item if selected.
        selectedItems.add(item);
      } else {
        // Remove item if not selected in new selection.
        selectedItems.remove(item);
      }
    });
  }

  // This function is called when the cancel button is hit.
  void cancel() {
    Navigator.pop(context);
  }

  // This function called when the submit button is hit.
  void submit() {
    Navigator.pop(context, selectedItems);
  }

  // A pop-up window will allow user to select event tags.
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Select Event Tags'),
        content: SingleChildScrollView(
          child: ListBody(
            children: widget.elements
                // Display event tags and change their selected status according to if they're pressed.
                .map((item) => CheckboxListTile(
                    value: selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => itemChange(item, isChecked!)))
                .toList(),
          ),
        ),
        actions: [
          // Cancel and submit button actions. 
          TextButton(onPressed: cancel, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: submit,
            child: const Text('Submit'),
          )
        ]);
  }
} // MultiSelectState

// Define a stateful widget for event creation that is mutable and its corresponding state class.
class UserEventCreationPage extends StatefulWidget {
  const UserEventCreationPage({super.key});
  @override
  State<UserEventCreationPage> createState() => UserEventCreationPageState();
}

// The state class to manage mutable state data and the widget's lifecycle for event creation page.
class UserEventCreationPageState extends State<UserEventCreationPage> {
  late String? _org;
  late final TextEditingController _title;
  late final TextEditingController _location;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late final TextEditingController _description;
  late bool? _studentsOnly;
  late List<String> _tags;
  late String _tagsString; // This string is a conversion of the list above to a comma-separated string.
  late String? _repeat;
  late final TextEditingController _repeatDate;
  late List<DropdownMenuItem<String>> _studentOrgs;

  // initState function initializes all of the late final variables from above. 
  @override
  void initState() {
    _org = null; 
    super.initState();
    _title = TextEditingController();
    _location = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
    _description = TextEditingController();
    _studentsOnly = false;
    _tags = [];
    _tagsString = "";
    _repeat = null;
    _repeatDate = TextEditingController();
    _studentOrgs = List.generate(STUDENTORGS.length,
                                (index) => DropdownMenuItem(
                                  value: STUDENTORGS[index],
                                  child: Text(STUDENTORGS[index],
                                  ),
                                ),
                                );
    
  } // initState

  // dispose function does the cleanup tasks.
  @override
  void dispose() {
    // _orgId.dispose(); TODO: Uncomment when we implement student orgs.
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
      // If this is for the repeat end date, we only want the date. So we have the date and we save date to the controller's text as a string.
      if (control == _repeatDate) {
        final DateTime userRepeatDate =
            DateTime(userDate.year, userDate.month, userDate.day);
        setState(() {
          control.text = userRepeatDate.toString();
        });
      }

      // Otherwise, get the time.
      else {
        // Show time picker to user with limited range.
        final TimeOfDay? userTime = await showTimePicker(
            context: context,
            initialTime:
                TimeOfDay.now() // Initial time will be the current time.
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
    }
  } // selectDateTime

  // showMultiSelect function allows users to multiselect event tags.
  void showMultiSelect() async {
    // This is the list of event tags.
    final List<String> items = ALLTAGS;

    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(elements: items);
        });

    // Update UI. 
    if (results != null) {
      setState(() {
        _tags = results;
      });
    }

    // Update variable to send tags to backend; create a comma-separated string.
    _tagsString = _tags.join(',');
  } // showMultiSelect

// Build UI of widget. 
// Everything is wrapped in a container with child content being scrollable.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      // Arrange children vertically.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                        visible: _studentOrgs.isNotEmpty,
                        child: DropdownButton<String>(
                            hint: const Text(
                                'Select a Student Org to be Linked to your Event'),
                            items: _studentOrgs,
                            isExpanded: true,
                            value: _org,
                            onChanged: (newValue) {
                              setState(() {
                                _org = newValue;
                              });
                            }),
                        ),
                        const SizedBox(height: 10),
                        
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
      
                        const SizedBox(height: 10), // This is the gap in between text fields.
      
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
                          readOnly: true, // Don't ask for text keyboard input.
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
      
                        // REPEATING EVENT OPTIONS DISPLAYS HERE.
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
      
                        // END REPEAT DATE DISPLAYS HERE.
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
      
                        // DISPLAY CHOSEN EVENT TAGS BELOW THE BUTTON.
                        Wrap(
                          children: _tags
                              .map((e) => Chip(
                                    label: Text(e),
                                  ))
                              .toList(),
                        ),
      
                        const SizedBox(height: 10),
      
                        // CREATE EVENT BUTTON SENDS INFORMATION TO BACKEND
                        SizedBox(
                            width: double.infinity, // Span the whole screen.
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 143, 28),
                                    foregroundColor: Colors.black),
                                // When the button is pressed, do this:
                                onPressed: () async {
                                  // Send event info to backend.
                                  // There is no event ID yet, so send -1 for that variable.
                                  // Send to the Create Event URL. 
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
                                      -1,
                                      'https://grinsync.com/api/create/event');
      
                                  if (create.runtimeType == String) {
                                    // Show error messages from the backend.
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Event Creation Error'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text('$create'),
                                                const Text('Please edit event details.')
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
      
                                  // Otherwise, event info was successfully sent to backend.
                                  // Show success message.
                                  // TODO: Reload the page. 
                                  else {
                                    Fluttertoast.showToast(
                                        msg: 'Event Created Successfully!',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey[300],
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                  }
                                },
                                child: const Text('Create Event') // Button title
                                ))
                      ]))));
  } // build
} // EventCreationPageState
