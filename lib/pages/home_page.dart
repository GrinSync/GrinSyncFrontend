import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/models/event_models.dart';


// HomePage shows user a list of events

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> allEvents = getAllEvents();



  // event fields are on trello

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //event tabs to scroll through
      body: ListView.builder(
        itemCount: allEvents.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Event $index'),
              subtitle: Text('Event Description $index'),
              onTap: () {
                // navigate to event details page
              },
            ),
          );
        },
      ),
    );
  }
}


List<Event> getSampleEvents() {
  List<Event> allEvents = <Event>[];
  allEvents.add(Event(
    title: 'Event 1',
    location: 'Location 1',
    description: 'Event Description 1',
    startDate: 'Time 1',
    endDate: 'Date 1',
    studentOnly: true,
    foodDrinks: true,
    feeRequired: true,
    tags: ['Tag 1', 'Tag 2'],
  ));
  allEvents.add(Event(
    title: 'Event 2',
    description: 'Event Description 2',
    location: 'Location 2',
    time: 'Time 2',
    date: 'Date 2',
    tags: ['Tag 3', 'Tag 4'],
    attendees: ['Attendee 3', 'Attendee 4'],
    host: 'Host 2',
  ));
  allEvents.add(Event(
    title: 'Event 3',
    description: 'Event Description 3',
    location: 'Location 3',
    time: 'Time 3',
    date: 'Date 3',
    tags: ['Tag 5', 'Tag 6'],
    attendees: ['Attendee 5', 'Attendee 6'],
    host: 'Host 3',
  ));
  return allEvents;
}

List<Event> getAllEvents() {
  List<Event> events = <Event>[];
  // TODO: get events from database
  // to be implemented
  return events;
}