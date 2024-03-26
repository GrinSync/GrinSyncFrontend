import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/main.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});
  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  late final TextEditingController _org_id;
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _date;
  late final TextEditingController _start_date;
  late final TextEditingController _end_date;
  late final TextEditingController _location;
  late final TextEditingController _students_only;
  late final TextEditingController _tags;

  @override
  void initState() {
    _org_id = TextEditingController();
    _title = TextEditingController();
    _description = TextEditingController();
    _date = TextEditingController();
    _start_date = TextEditingController();
    _end_date = TextEditingController();
    _location = TextEditingController();
    _students_only = TextEditingController();
    _tags = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _org_id.dispose();
    _title.dispose();
    _description.dispose();
    _date.dispose();
    _start_date.dispose();
    _end_date.dispose();
    _location.dispose();
    _students_only.dispose();
    _tags.dispose();
    super.dispose();
  }

  // To pick date and time from user
  Future <void> _selectDateTime(BuildContext context, TextEditingController c) async {
    final DateTime? _userDate = await showDatePicker(
      context: context, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100));

    if (_userDate != null) {
      final TimeOfDay? _userTime = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.now());

      if (_userTime != null) {
        final DateTime _userDateTime = DateTime(
          _userDate.year,
          _userDate.month,
          _userDate.day,
          _userTime.hour,
          _userTime.minute);
        
        // save to controller as a string
        setState(() {
          c.text = _userDateTime.toString();
        });
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
              controller: _title,
              autocorrect: false,
              enableSuggestions: false,
              maxLines: null,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.create),
                  labelText: 'Event Title',
                  hintText: 'Enter the title of your event',
                  border: OutlineInputBorder()),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _location,
              autocorrect: false,
              enableSuggestions: false,
              maxLines: null,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined),
                labelText: 'Location',
                hintText: 'Enter the location of your event',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _start_date,
              readOnly: true,
              onTap: () => _selectDateTime(context, _start_date),
              
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.access_time_filled),
                labelText: 'Starts',
                hintText: 'Pick the starting date & time of your event',
                border: OutlineInputBorder(),
                
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _end_date,
              readOnly: true,
              onTap: () => _selectDateTime(context, _end_date),
              
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.access_time),
                labelText: 'Ends',
                hintText: 'Pick the ending date & time of your event',
                border: OutlineInputBorder(),
                
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _description,
              autocorrect: false,
              enableSuggestions: false,
              maxLines: null,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.summarize_outlined),
                labelText: 'Description',
                hintText: 'Enter a description of your event',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

          // TODO 
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  onPressed: () async {
                    var auth =
                        await eventInfo(_title.text, _description.text, _date.text, _location.text);
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
                  child: const Text('Create Event')),
            )

          ]),
        )));
  }
}