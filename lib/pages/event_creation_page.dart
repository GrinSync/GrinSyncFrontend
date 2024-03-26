import 'package:flutter/material.dart';

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
  late final TextEditingController _location;
  late final TextEditingController _students_only;
  late final TextEditingController _tags;

  @override
  void initState() {
    _org_id = TextEditingController();
    _title = TextEditingController();
    _description = TextEditingController();
    _date = TextEditingController();
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
    _location.dispose();
    _students_only.dispose();
    _tags.dispose();
    super.dispose();
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
              decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'Enter the title of your event',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _date,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Date',
                hintText: 'Enter the date of your event',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _location,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Enter the location of your event',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
          ]),
        )));
  }
}