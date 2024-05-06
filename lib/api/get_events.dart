import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as https;
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/pages/event_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test_app/pages/edit_event_page.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_test_app/global.dart';

/// This event card allows user to like the event if they are logged in.
/// Use the other card 'EventCardPlain' when the user doesn't need to
/// favorite the event when you show them.
/// This is used on home page and search page.
class EventCardFavoritable extends StatelessWidget {
  const EventCardFavoritable({
    super.key,
    required this.event,
    required this.refreshParent
  });
  final Event event;
  final VoidCallback refreshParent;

  @override
  Widget build(BuildContext context) {
    var favorited = ValueNotifier(event.isFavorited);

    return ValueListenableBuilder(
        valueListenable: favorited,
        builder: (context, value, child) {
          return Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: value
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                    width: value ? 2 : 1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              tileColor: value ? null : Colors.white,
              title: Text(event.title ?? 'Null title',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800)),
              subtitle: Text(
                  'Location: ${event.location}\nStarts at: ${timeFormat(event.start)}',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700])),
              isThreeLine: true,
              trailing: IconButton(
                icon: value
                    ? Icon(Icons.favorite,
                        color: Theme.of(context).colorScheme.primary)
                    : Icon(Icons.favorite_border,
                        color: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  if (isLoggedIn()) {
                    // Update the event's favorited status in the database
                    toggleLikeEvent(event.id);
                    // Update the event's favorited status in the frontend (for the purpose of displaying the right icon without having to pull from the database again)
                    event.isFavorited = !value;
                    favorited.value = !value;
                    // Show a toast message to confirm the event is saved or unsaved
                    Fluttertoast.showToast(
                        msg: value
                            ? 'Unsaved successfully'
                            : 'Saved successfully',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[800],
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    // If the user is not logged in, show a toast message to prompt the user to log in
                    Fluttertoast.showToast(
                        msg: 'Please log in to save events',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[800],
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => EventDetailsPage(event: event, refreshParent: refreshParent),
                  ),
                );
              },
            ),
          );
        });
  }
}

/// This event card is used to show events on the home page when the user
/// is not logged in or in the user's own list (e.g. in events I created page)
class EventCardPlain extends StatelessWidget {
  const EventCardPlain({
    super.key,
    required this.event,
    required this.refreshParent
  });
  final Event event;
  final VoidCallback refreshParent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        tileColor: Colors.white,
        title: Text(event.title ?? 'Null title',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        subtitle: Text(
            'Location: ${event.location}\nStarts at: ${timeFormat(event.start)}',
            style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        isThreeLine: true,
        // trailing: IconButton(
        //   icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.primary),
        //   onPressed: () {
        //     deleteEvent(event.id);
        //   }),
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                //go to event details page
                builder: (context) => EventDetailsPage(event: event, refreshParent: refreshParent),
              ));
        },
      ),
    );
  }
}

/// Formats the time string to a more readable format (YYYY-MM-DD HH:MM)
String timeFormat(String? timeString) {
  if (timeString == null) {
    return 'Null time';
  }

  DateTime dateTimeObj = DateTime.parse(timeString);

  String year = dateTimeObj.year.toString();
  String month = dateTimeObj.month.toString();
  String day = dateTimeObj.day.toString();

  List<String> allMonths = [
    "Jan",
    "Feb",
    "Mar",
    "April",
    "May",
    "June",
    "July",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  switch (month) {
    case "1":
      month = allMonths[0];
    case "2":
      month = allMonths[1];
    case "3":
      month = allMonths[2];
    case "4":
      month = allMonths[3];
    case "5":
      month = allMonths[4];
    case "6":
      month = allMonths[5];
    case "7":
      month = allMonths[6];
    case "8":
      month = allMonths[7];
    case "9":
      month = allMonths[8];
    case "10":
      month = allMonths[9];
    case "11":
      month = allMonths[10];
    case "12":
      month = allMonths[11];

      break;
    default:
  }

  // Example of full timeString: 2024-04-30 06:00"
  // We extract the entire substring for HH:MM instead of extracting it from the DateTime object
  // If extract from the DateTime object, it will look like: "6:0"
  String time = timeString.substring(11, 16);

  return '${time} ${month} ${day}, ${year}';
}

Future<String> deleteEvent(int eventId) async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  Map<String, String> body = {
    'id': eventId.toString(),
  };

  var url = Uri.parse('https://grinsync.com/api/deleteEvent');
  var response = await https.delete(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    return 'Event deleted successfully';
  } else {
    return response.body;
  }
}

Future<void> toggleLikeEvent(int eventId) async {
  // var box = await Hive.openBox(tokenBox);
  var token = BOX.get('token');
  //box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/toggleLikedEvent');
  var response =
      await https.post(url, headers: headers, body: {'id': eventId.toString()});

  if (response.statusCode == 200) {
    print('Event liked/unliked');
  } else {
    print('Failed to like/unlike event');
  }
}

Future<void> unlikeEvent(int eventId) async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri(
    scheme: 'https',
    host: 'grinsync.com',
    path: 'api/unlikeEvent',  
  );

  var response = await https.post(url, headers: headers, body: {'id': eventId.toString()});

  if (response.statusCode == 200) {
    print('Event unliked');
  } else {
    print('Failed to unlike event');
  }
}

/// Gets all event from the backend
Future<List<Event>> getAllEvents() async {
  List<Event> allEvents = [];

  // print('Connecting...');

  // var box = await Hive.openBox(tokenBox);
  var token = BOX.get('token');
  //box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  print('Fetching events...');
  var url = Uri.parse('https://grinsync.com/api/getAll');
  var result = await https.get(url, headers: headers);

  // print('Parsing JSON response...');

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    allEvents.add(newEvent);
  }

  // print('Returning events...');

  return allEvents;
}

/// Gets all events filtered by studentsOnly and selected tags
Future<List<Event>> getAllEventsByPreferences(
    tagList, studentOnly, intersectionFilter) async {
  List<Event> allEvents = [];

  // print('Connecting...');

  // var box = await Hive.openBox(tokenBox);
  var token = BOX.get('token');
  //box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  print('Fetching events...');
  var url = Uri.parse('https://grinsync.com/api/getAll');
  var result = await https.get(url, headers: headers);

  // print('Parsing JSON response...');

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    allEvents.add(newEvent);
  }

  // print('Returning events...');

  // filter the events based on the user's preferences
  if (studentOnly) {
    // only show studentOnly events
    allEvents = allEvents
        .where((event) => event.studentsOnly == true)
        .toList(); // list.where returns a new list with only the elements that satisfy the condition
  }
  if (intersectionFilter) {
    // only show events that have all selected tags
    allEvents = allEvents
        .where((event) => tagList.every((tag) => event.tags!.contains(tag)))
        .toList(); // list.every returns true if all elements satisfy the condition
  }

  return allEvents;
}

/// Get all upcoming events filtered by studentsOnly and selected tags
Future<List<Event>> getUpcomingEvents(
    tagList, studentOnly, intersectionFilter) async {
  List<Event> allEvents = [];

  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url =
      Uri.parse('https://grinsync.com/api/upcoming?tags=${tagList.join(';')}');
  var result = await https.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    allEvents.add(newEvent);
  }

  // filter the events based on the user's preferences
  if (studentOnly) {
    // only show studentOnly events
    allEvents = allEvents
        .where((event) => event.studentsOnly == true)
        .toList(); // list.where returns a new list with only the elements that satisfy the condition
  }
  if (intersectionFilter) {
    // only show events that have all selected tags
    allEvents = allEvents
        .where((event) => tagList.every((tag) => event.tags!.contains(tag)))
        .toList(); // list.every returns true if all elements satisfy the condition
  }


  allEvents = allEvents.toSet().toList(); // remove duplicates if any
  // for (var event in allEvents) { // but it still contains duplicates
  //   print(event.id);
  // }
  

  return allEvents;
}

/// Gets all events created by the current user (assuming the user is logged in)
Future<List<Event>> getMyEvents() async {
  List<Event> myEvents = [];

  // var box = await Hive.openBox(tokenBox);
  var token = BOX.get('token');
  //box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/getCreatedEvents');
  var result = await https.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    myEvents.add(newEvent);
  }

  return myEvents;
}

/// Gets all events followed by the current user (assuming the user is logged in)
Future<List<Event>> getLikedEvents() async {
  List<Event> likedEvents = [];

  // var box = await Hive.openBox(tokenBox);
  var token = BOX.get('token');
  //box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/getLikedEvents');
  var result = await https.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    likedEvents.add(newEvent);
  }

  return likedEvents;
}

/// Gets all searched events by query keyword
Future<List<Event>> getSearchedEvents(String keyword) async {
  List<Event> searchedEvents = [];
  // var box = await Hive.openBox(tokenBox);
  var token = BOX.get('token');
  //box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  var url = Uri.parse('https://grinsync.com/api/search?query=$keyword');
  var result = await https.get(url, headers: headers);
  // print(result.body);
  // print('Parsing JSON response...');

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    searchedEvents.add(newEvent);
  }
  return searchedEvents;
}

/// Gets an event by ID
Future<Event?> getEventByID(eventID) async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/getEvent?id=$eventID');
  var result = await https.get(url, headers: headers);

  print(result.body);

  if (result.statusCode == 200) {
    var json = jsonDecode(result.body);
    Event event = Event.fromJson(json);
    return event;
  } else {
    return null;
  }
}

// Gets all events created by a certain student organization
Future<List<Event>> getOrgEvents(orgID) async {
  List<Event> orgEvents = [];

  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/getOrgEvents?id=$orgID');
  var result = await https.get(url, headers: headers);

  if (result.statusCode == 200) {
    for (var jsonEvent in jsonDecode(result.body)) {
      Event newEvent = Event.fromJson(jsonEvent);
      orgEvents.add(newEvent);
    }
    return orgEvents;
  } else {
    return [];
  }
}