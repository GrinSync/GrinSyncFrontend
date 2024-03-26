import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/main.dart';

// TODO: NO SAVE DRAFT OPTION; IF USERS EXIT THE CREATE EVENT PAGE ALL THEIR INPUT IS LOST

// Define a stateful widget that is mutable and its corresponding state class
class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});
  @override
  State<EventCreationPage> createState() => EventCreationPageState();
}

// Define the state class to manage mutable state data and the widget's lifecycle
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
  late final TextEditingController _studentsOnly;
  late final TextEditingController _tags;

  // initState function to initialize all of the late final variables from above 
  @override
  void initState() {
    // _orgId = TextEditingController(); TODO: Uncomment when we implement student orgs
    _title = TextEditingController();
    _location = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
    _description = TextEditingController();
    _studentsOnly = TextEditingController();
    _tags = TextEditingController();
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
    _studentsOnly.dispose();
    _tags.dispose();
    super.dispose();
  } // dispose

  // selectDateTime function to allow users to select date and time for their events 
  // in the built-in date and time widgets of Flutter
  Future <void> selectDateTime(BuildContext context, TextEditingController control) async {
    
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
        final DateTime userDateTime = DateTime(
          userDate.year,
          userDate.month,
          userDate.day,
          userTime.hour,
          userTime.minute
        ); // userDateTime
        
        // Save date-time to the controller's text as a string
        setState(() {
          control.text = userDateTime.toString();
        });
      }
    }
  } // selectDateTime

// Build UI of widget
// Everything is wrapped in a container with child content being scrollable
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column( // Arrange children vertically
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
                  border: OutlineInputBorder()
                ),
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
                  border: OutlineInputBorder()
                ),
              ),

              const SizedBox(height: 10),

              // EVENT START TIME BOX
              TextField(
                controller: _startDate,
                readOnly: true, // Don't ask for text keyboard input
                onTap: () => selectDateTime(context, _startDate),
                decoration: const InputDecoration(
                  icon: Icon(Icons.access_time_filled),
                  labelText: 'Event Starts...',
                  hintText: 'Pick the starting date & time of your event',
                  border: OutlineInputBorder()
                ),
              ),

              const SizedBox(height: 10),

              // EVENT END TIME BOX
              TextField(
                controller: _endDate,
                readOnly: true,
                onTap: () => selectDateTime(context, _endDate),
                decoration: const InputDecoration(
                  icon: Icon(Icons.access_time),
                  labelText: 'Event Ends...',
                  hintText: 'Pick the ending date & time of your event',
                  border: OutlineInputBorder()
                ),
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
                  icon: Icon(Icons.summarize_outlined)
                ),
              ),

              const SizedBox(height: 10),

              // CREATE EVENT BUTTON - SEND INFO TO BACKEND
              SizedBox(
                width: double.infinity, // Span the whole screen
                child: ElevatedButton(
                  style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                    // When the button is pressed, do this:
                    onPressed: () async {
                      var auth = await eventInfo(_title.text, _description.text, _startDate.text, _location.text);
                            if (auth.runtimeType == String) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Login Failed'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'The Lgin credentials provided do not match a user.'),
                                          Text(
                                              'Please re-enter your credentials and try again.'),
                                        ],
                                      ),
                                    ),
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
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MyApp()),
                              );
                            }
                          },
                  child: const Text('Create Event') // Button title
                )
              )
          ])
        )
      )
    );
  } // build
}