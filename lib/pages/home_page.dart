import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/pages/event_details_page.dart';

// HomePage shows user a list of events

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> allEvents = getSampleEvents();



  // event fields are on trello

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //event cards
      body: ListView.builder(
        itemCount: allEvents.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              // leading: event image?
              title: Text(allEvents[index].title ?? 'Null title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              subtitle: Text('${allEvents[index].location ?? 'Null location'}\n${allEvents[index].startDate ?? 'Null start date'} - ${allEvents[index].endDate ?? 'Null end date'}', style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              isThreeLine: true,
              // trailing: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary), // favorite button to favorite an event
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsPage(event: allEvents[index]),
                  ),
                );
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
    title: '60s Harris',
    location: 'Harris Center',
    description: 'Random event description Random event description Random event description Random event description Random event description',
    startDate: '04/06/2024 22:00',
    endDate: '04/07/2024 1:00',
    studentOnly: true,
    foodDrinks: true,
    feeRequired: false,
    tags: [],
  ));
  allEvents.add(Event(
    title: 'CSC 324 Study Session',
    location: 'Noyce 3815',
    description: 'We will be preparing for the upcoming presentation',
    startDate: '04/10/2024 19:00',
    endDate: '04/10/2024 21:00',
    studentOnly: true,
    foodDrinks: false,
    feeRequired: false,
    tags: [],
  ));
  allEvents.add(Event(
    title: 'Ten Ten Party',
    location: '1010 High St',
    description: 'You know what it is',
    startDate: '10/10/2024 22:00',
    endDate: '10/11/2024 4:00',
    studentOnly: true,
    foodDrinks: true,
    feeRequired: false,
    tags: [],
  ));
  return allEvents;
}

List<Event> getAllEvents() {
  List<Event> events = <Event>[];
  // TODO: get events from database
  // to be implemented
  return events;
}