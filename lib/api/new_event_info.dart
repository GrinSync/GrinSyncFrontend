import 'dart:convert';
import 'package:flutter_test_app/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as https;

// Asyncrhonus operation to send newly created event information to the Django backend
// User input: userTitle, userLocation, userStartDate, userEndDate, userDescription, userRepeat, userEndRepeat, userStudentOnly, userTags
Future eventInfo(
    String userTitle,
    String userLocation,
    String userStartDate,
    String userEndDate,
    String userDescription,
    String? userRepeat,
    String userEndRepeat,
    bool? userStudentOnly,
    String userTags) async {
  if (userStudentOnly == null) return; // Error check
  String studentOnly =
      (userStudentOnly ? "True" : "False"); // Set boolean to a String

  // Set repeat customizations to numbers 
  // Daily -> repeatingDays = 1
  // Weekly -> repeatingDays = 7
  // Monthly -> repeatingMonths = 1
  // Otherwise, 0
  // Send as Strings because that is how the backend will want it
  String repeatingDays = "0";
  String repeatingMonths = "0";
  if (userRepeat != null) {
    if (userRepeat == 'Daily') {
      repeatingDays = "1";
    }
    else if (userRepeat == 'Weekly') {
      repeatingDays = "7";
    }
    else if (userRepeat == 'Monthly') {
      repeatingMonths = "1";
    }
  }

  // 'body' stores all the event info in a single map data structure
  // Map backend API variables to user input
  Map body = {
    'title': userTitle,
    'location': userLocation,
    'start': userStartDate,
    'end': userEndDate,
    'description': userDescription,
    'repeatingDays': repeatingDays,
    'repeatingMonths': repeatingMonths,
    'repeatDate': userEndRepeat,
    'studentsOnly': studentOnly,
    'tags': userTags,
  }; // body

  // TO DO: Ask Bradley what this does
  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
  Map<String, String> headers = {'Authorization': 'Token $token'};

  var url = Uri.parse('https://grinsync.com/api/create/event');
  // URL to send new event info
  var result = await https.post(url, body: body, headers: headers);

  // This is how to check the error key
  var json = jsonDecode(result.body);
  // Check for invalid input/missing information
  // Return an int if that's the case
  if (json.containsKey('error')) {
    return 1;
  }

  // If the login was not successful, we return a String so we can send an error message to the user
  if (result.statusCode != 200) {
    return 'failed';
  }
} // eventInfo
