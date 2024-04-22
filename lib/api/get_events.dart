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

/// This event card leads user to the event details page. It's used when user can't edit an event (e.g. on home page and events I follow page)
class EventCardtoDetails extends StatelessWidget {
  const EventCardtoDetails({
    super.key,
    required this.event,
  });
  final Event event;

  @override
  Widget build(BuildContext context) {
    var favorited = ValueNotifier(event.isFavoited);

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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              subtitle: Text(
                  'Location: ${event.location}\nStarts at: ${timeFormat(event.start)}',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700])),
              isThreeLine: true,
              trailing: isLoggedIn()
                  ? IconButton(
                      icon: value
                          ? Icon(Icons.favorite,
                              color: Theme.of(context).colorScheme.primary)
                          : Icon(Icons.favorite_border,
                              color: Theme.of(context).colorScheme.primary),
                      onPressed: () {
                        toggleLikeEvent(event.id);
                        event.isFavoited = !value;
                        favorited.value = !value;
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
                      },
                    )
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => EventDetailsPage(event: event),
                  ),
                );
              },
            ),
          );
        });
  }
}

/// This event card leads user to the event edit page. It's used when user can edit an event (e.g. on events I created page)
class EventCardtoEdit extends StatelessWidget {
  const EventCardtoEdit({
    super.key,
    required this.event,
  });

  final Event event;

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
                //go to event edit page
                builder: (context) => EventEditPage(event: event),
              ));
        },
      ),
    );
  }
}

/// This function formats the time string to a more readable format (YYYY-MM-DD HH:MM)
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

  // String hour = dateTimeObj.hour.toString();
  // String minute = dateTimeObj.minute.toString();

  String time = timeString.substring(11, 16);

  return '${time} ${month} ${day}, ${year}';
}

Future<void> deleteEvent(int eventId) async {
  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
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
  var response =
      await https.delete(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Event deleted');
  } else {
    print(response.body);
  }
}

Future<void> toggleLikeEvent(int eventId) async {
  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
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

Future<List<Event>> getAllEvents() async {
  List<Event> allEvents = [];

  // print('Connecting...');

  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
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

Future<List<Event>> getUpcomingEvents() async {
  List<Event> allEvents = [];

  //print('Connecting...');

  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  //print('Fetching events...');
  var url = Uri.parse('https://grinsync.com/api/upcoming');
  var result = await https.get(url, headers: headers);

  //print('Parsing JSON response...');

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    allEvents.add(newEvent);
  }

  //print('Returning events...');

  return allEvents;
}

// this function gets the events created by the current user (assuming the user is logged in)
Future<List<Event>> getMyEvents() async {
  List<Event> myEvents = [];

  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
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

// this function gets the events followed by the current user (assuming the user is logged in)
Future<List<Event>> getLikedEvents() async {
  List<Event> likedEvents = [];

  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
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

Future<List<Event>> searchEvents(String query) async {
  List<Event> searchResults = [];

  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/search?query=$query');
  var result = await https.get(url, headers: headers);

  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    searchResults.add(newEvent);
  }

  return searchResults;
}
