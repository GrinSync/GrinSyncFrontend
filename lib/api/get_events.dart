import 'dart:convert';
import 'package:flutter_test_app/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as https;
import 'package:flutter_test_app/models/event_models.dart';



Future<List<Event>> getAllEvents() async {
  List<Event> allEvents = [];

  print('Connecting...');

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
  var url = Uri.parse('https://grinsync.com/api/upcoming');
  var result = await https.get(url, headers: headers);

  print('Parsing JSON response...');

  // parse the json response and create a list of Event objects
  // result.body is a list of maps with event information
  for (var jsonEvent in jsonDecode(result.body)) {
    Event newEvent = Event.fromJson(jsonEvent);
    allEvents.add(newEvent);
  }

  print('Returning events...');

  return allEvents;
}