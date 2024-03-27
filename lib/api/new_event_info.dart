import 'package:http/http.dart' as https;

// TO DO
Future eventInfo(String userTitle, String userLocation, String userStartDate, String userEndDate, String userDescription, bool? userStudentOnly) async {
  
  // 'body' stores all the event info in a single map data structure
  Map body = {
    'title': userTitle,
    'location': userLocation,
    'date': userStartDate,
    'description': userDescription,
  }; // body

  var url = Uri.parse('https://grinsync.com/api/create/event'); // URL to send new event info
  var result = await https.post(url, body: body);

  // If the login was not successful, we return a String so we can send an error message to the user
  if (result.statusCode != 200) {
    return 'Event Creation Failed';
  } 
} // eventInfo