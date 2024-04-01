import 'package:flutter_test_app/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as https;

// TO DO
Future eventInfo(String userTitle, String userLocation, String userStartDate,
    String userEndDate, String userDescription, bool? userStudentOnly) async {
  if (userStudentOnly == null) return;
  String studentOnly = (userStudentOnly ? "True" : "False");

  // 'body' stores all the event info in a single map data structure
  Map body = {
    'title': userTitle,
    'location': userLocation,
    'start': userStartDate,
    'studentsOnly': studentOnly,
    'description': userDescription,
  }; // body
  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();
  Map<String, String> headers = {'Authorization': 'Token $token'};

  var url = Uri.parse('https://grinsync.com/api/create/event');
  // URL to send new event info
  var result = await https.post(url, body: body, headers: headers);
  print(result.body);
  // If the login was not successful, we return a String so we can send an error message to the user
  if (result.statusCode != 200) {
    return 'Event Creation Failed';
  }
} // eventInfo
