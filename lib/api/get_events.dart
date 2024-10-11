import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grinsync/models/event_models.dart';
import 'package:grinsync/pages/event_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:grinsync/api/user_authorization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grinsync/global.dart';

/// This event card allows user to favorite the event if they are logged in.
/// Use the other card 'EventCardPlain' when the user doesn't need to
/// favorite the event when you show them.
/// This is used on home page and search page.
class EventCardFavoritable extends StatelessWidget {
  const EventCardFavoritable(
      {super.key, required this.event, required this.refreshParent});
  final Event event;
  final VoidCallback refreshParent;

  @override
  Widget build(BuildContext context) {
    var favorited = ValueNotifier(event.isFavorited);

    return ValueListenableBuilder(
        // listens to any changes in whether the event is favorited
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
              title: Text(event.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800)),
              subtitle: Text(
                  'Location: ${event.location}\nStarts at: ${timeFormat(event.start)}',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700])),
              isThreeLine: true,
              // The favorite button
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
                            ? 'Unfavorited successfully'
                            : 'Favorited successfully',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[800],
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    // If the user is not logged in, show a toast message to prompt the user to log in
                    Fluttertoast.showToast(
                        msg: 'Please log in to favorite events',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[800],
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
              // Navigates to the Event Details page if the user taps on the event card
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => EventDetailsPage(
                        event: event, refreshParent: refreshParent),
                  ),
                );
              },
            ),
          );
        });
  }
}

/// This event card is used to show events on the home page when the user
/// is not logged in or in the user's own list (e.g. in Events I Created page)
class EventCardPlain extends StatelessWidget {
  const EventCardPlain(
      {super.key, required this.event, required this.refreshParent});
  final Event event;
  final VoidCallback refreshParent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        tileColor: Colors.white,
        title: Text(event.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        subtitle: Text(
            'Location: ${event.location}\nStarts at: ${timeFormat(event.start)}',
            style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        isThreeLine: true,
        // Navigates to the Event Details page if the user taps on the event card
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => EventDetailsPage(
                    event: event, refreshParent: refreshParent),
              ));
        },
      ),
    );
  }
}

/// Deletes an event by ID
Future<String> deleteEvent(int eventId) async {
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Deletes the event whose ID matches the argument
  var url = Uri.parse('https://grinsync.com/api/deleteEvent');
  var response = await http
      .delete(url, headers: headers, body: {'id': eventId.toString()});

  if (response.statusCode == 200) {
    return 'Event deleted successfully';
  } else {
    return response.body;
  }
}

/// Claim an event by ID
Future<String> claimEvent(int eventId) async {
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Deletes the event whose ID matches the argument
  var url = Uri.parse('https://grinsync.com/api/claimEvent');
  var response = await http
      .post(url, headers: headers, body: {'id': eventId.toString()});

  if (response.statusCode == 200) {
    return 'Email sent successfully';
  } else {
    return response.body;
  }
}

/// Gets all event
Future<List<Event>> getAllEvents() async {
  List<Event> allEvents = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all events from the server
  var url = Uri.parse('https://grinsync.com/api/getAll');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    allEvents.add(newEvent);
  }

  return allEvents;
}

/// Gets all events filtered by studentsOnly and selected tags
Future<List<Event>> getAllEventsByPreferences(
    tagList, studentOnly, intersectionFilter) async {
  List<Event> allEvents = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all events that match the list of selected tags
  // Converts the list of tags to a string of tags separated by semi-colons
  // for compatibility with the server
  var url =
      Uri.parse('https://grinsync.com/api/getAll?tags=${tagList.join(';')}');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    allEvents.add(newEvent);
  }

  // Only show studentOnly events if preferred by the user
  if (studentOnly) {
    allEvents = allEvents
        .where((event) => event.studentsOnly == true)
        .toList(); // list.where returns a new list with only the elements that satisfy the condition
  }

  // Only show events that have all the selected tags
  if (intersectionFilter) {
    allEvents = allEvents
        .where((event) => tagList.every((tag) => event.tags!.contains(tag)))
        .toList(); // list.every returns true if all elements satisfy the condition
  }

  // Returns after proper filtering
  return allEvents;
}

/// Gets an event by ID
Future<Event?> getEventByID(eventID) async {
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets the event whose ID matches the argument
  var url = Uri.parse('https://grinsync.com/api/getEvent?id=$eventID');
  var result = await http.get(url, headers: headers);

  if (result.statusCode == 200) {
    var json = jsonDecode(result.body);
    Event event = Event.fromJson(json);
    return event;
  } else {
    return null;
  }
}

/// Gets all events favorited by the current user (assuming the user is logged in)
Future<List<Event>> getLikedEvents() async {
  List<Event> likedEvents = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all events followed by the current user
  var url = Uri.parse('https://grinsync.com/api/getLikedEvents');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    likedEvents.add(newEvent);
  }
  return likedEvents;
}

/// Gets all events created by the current user (assuming the user is logged in)
Future<List<Event>> getMyEvents() async {
  List<Event> myEvents = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all events created by the current user
  var url = Uri.parse('https://grinsync.com/api/getCreatedEvents');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    myEvents.add(newEvent);
  }
  return myEvents;
}

// Gets all events created by a certain student organization
Future<List<Event>> getOrgEvents(orgID) async {
  List<Event> orgEvents = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets the list of events whose org IDs match the argument
  var url = Uri.parse('https://grinsync.com/api/getOrgEvents?id=$orgID');
  var result = await http.get(url, headers: headers);

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

/// Gets all searched events by query keyword
Future<List<Event>> getSearchedEvents(String keyword) async {
  List<Event> searchedEvents = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all events that match a certain keyword given in the search bar
  var url = Uri.parse('https://grinsync.com/api/search?query=$keyword');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    searchedEvents.add(newEvent);
  }
  return searchedEvents;
}

/// Gets all upcoming events filtered by studentsOnly and selected tags
Future<List<Event>> getUpcomingEvents(
    tagList, studentOnly, intersectionFilter) async {
  List<Event> upcomingEvents = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all events that match the list of selected tags
  // Converts the list of tags to a string of tags separated by semi-colons
  // for compatibility with the server
  var url =
      Uri.parse('https://grinsync.com/api/upcoming?tags=${tagList.join(';')}');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    upcomingEvents.add(newEvent);
  }

  // Only show studentOnly events if preferred by the user
  if (studentOnly) {
    upcomingEvents = upcomingEvents
        .where((event) => event.studentsOnly == true)
        .toList(); // list.where returns a new list with only the elements that satisfy the condition
  }

  // Only show events that have all the selected tags
  if (intersectionFilter) {
    upcomingEvents = upcomingEvents
        .where((event) => tagList.every((tag) => event.tags!.contains(tag)))
        .toList(); // list.every returns true if all elements satisfy the condition
  }

  // Returns after proper filtering
  return upcomingEvents;
}

/// Toggle liked event by ID
Future<void> toggleLikeEvent(int eventId) async {
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Toggles the liked event whose ID matches the argument
  var url = Uri.parse('https://grinsync.com/api/toggleLikedEvent');
  var response =
      await http.post(url, headers: headers, body: {'id': eventId.toString()});

  if (response.statusCode == 200) {
    // print('Event liked/unliked');
  } else {
    // print(response.body);
  }
}

/// Unlike an event by ID
Future<void> unlikeEvent(int eventId) async {
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Unlike an event whose ID matches the argument
  var url = Uri.parse('https://grinsync.com/api/unlikeEvent');
  var response =
      await http.post(url, headers: headers, body: {'id': eventId.toString()});

  if (response.statusCode == 200) {
    // print('Event unliked');
  } else {
    // print(response.body);
  }
}

/// Formats the time string to a more readable format (YYYY-MM-DD HH:MM)
String timeFormat(String? timeString) {
  if (timeString == null) {
    return 'The time of the event is not specified';
  }

  // Parses the time string and converts to a DateTime object
  DateTime dateTimeObj = DateTime.parse(timeString);

  // Converts the day, month and year in the object to a string
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

  // Switch statement to convert month to the corresponding string
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

  return '$time $month $day, $year';
}
