import 'dart:convert';
import 'package:grinsync/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as https;

/// Asynchronus operation to send event information to the Django backend for editing and creating event.
Future eventInfo(
    String userTitle,
    String userLocation,
    String userStartDate,
    String userEndDate,
    String userDescription,
    String? userRepeat,
    String userEndRepeat,
    bool? userStudentOnly,
    String? userTags,
    String? org,
    int eventId,
    String userUrl) async {
  if (userStudentOnly == null) return; // Error check.
  String studentOnly =
      (userStudentOnly ? "True" : "False"); // Set boolean to a String.

  // Set repeat customizations to numbers.
  // Daily -> repeatingDays = 1
  // Weekly -> repeatingDays = 7
  // Monthly -> repeatingMonths = 1
  // Otherwise, 0
  // Send as Strings because that is how the backend will want it.
  String repeatingDays = "0";
  String repeatingMonths = "0";
  if (userRepeat != null) {
    if (userRepeat == 'Daily') {
      repeatingDays = "1";
    } else if (userRepeat == 'Weekly') {
      repeatingDays = "7";
    } else if (userRepeat == 'Monthly') {
      repeatingMonths = "1";
    }
  }

  // 'body' stores all the event info in a single map data structure.
  // We assign backend API variables to user input
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
  };
  // If the event ID is a valid ID, set the backend variable to the event ID
  // If this function gets a valid event ID, then we are editing an event and need to send the event ID.
  if (eventId >= 0) {
    body['id'] = eventId.toString();
  }
  // If the variable 'org' is not null, then the event is hosted by a student org and we need to send that info to the backend.
  if (org != null) {
    body['orgName'] = org;
  }

  // Get authorization token for API requests.
  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  Map<String, String> headers = {'Authorization': 'Token $token'};

  // Send info to the URL the user provides.
  // This is either the edit event URL or the create event URL.
  var url = Uri.parse(userUrl);
  var result = await https.post(url, body: body, headers: headers);

  // If the edit/create event can be successful but something is wrong with user input, return the reason why
  var json = jsonDecode(result.body);
  if (json.containsKey('error')) {
    return json['error'];
  }

  // If the edit/create event was not successful, return the reason why
  if (result.statusCode != 200) {
    return result.reasonPhrase;
  }
} // eventInfo
