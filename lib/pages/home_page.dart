import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/pages/event_details_page.dart';
import 'package:flutter_test_app/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as https;

// HomePage shows user a list of events

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  https.Response? events;
  bool APItest = true; // set to true to test API

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    events = await getAllEvents();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    if (APItest == true) {
      return Scaffold(
        body: Column(
          children: [
            Text(events?.body ?? 'events.body is null'),
          ],
        ),
      );
    } else {
    return Scaffold(
      body: const Placeholder(),
      /*
      ListView.builder(
        itemCount: allEvents.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              // leading: event image?
              title: Text(allEvents[index].title ?? 'Null title',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              subtitle: Text(
                  '${allEvents[index].location ?? 'Null location'}\n${allEvents[index].startDate ?? 'Null start date'} - ${allEvents[index].endDate ?? 'Null end date'}',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              isThreeLine: true,
              // trailing: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary), // favorite button to favorite an event
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EventDetailsPage(event: allEvents[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      */
    );
    }
  }
}

List<Event> getSampleEvents() {
  List<Event> allEvents = <Event>[];
  allEvents.add(Event(
    title: '60s Harris',
    location: 'Harris Center',
    description:
        'Random event description Random event description Random event description Random event description Random event description',
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


Future<https.Response> getAllEvents() async {
  //List<Event> events = <Event>[];

  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  var url = Uri.parse('https://grinsync.com/api/upcoming');
  var result = await https.get(url, headers: headers);

  return result;
}
