import 'package:http/http.dart' as https;

// TO DO
Future eventInfo(String userTitle, String userLocation, String userStartDate, String userEndDate, String userDescription) async {
  
  // 'body' stores all the event info in a single map data structure
  Map body = {
    'title': userTitle,
    'location': userLocation,
    'date': userStartDate,
    'description': userDescription,
  }; // body

  var url = Uri.parse('https://grinsync.com/api/create/event'); // URL to send new event info
  var result = await https.post(url, body: body);
  print(result.body); // This is for testing purposes only

  // If the login was successful, we can store the login token for future use
  if (result.statusCode == 200) {
    
  }
  else{
     return 'Login Failed';
  }
}
