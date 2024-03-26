import 'package:http/http.dart' as https;

// TO DO
Future eventInfo(String user_title, String user_description, String user_date, String user_location) async {
  
  // body stores the event in a single map data structure
  Map body = {
    'title': user_title,
    'description': user_description,
    'date': user_date,
    'location': user_location
  };
  var url = Uri.parse('https://grinsync.com/api/create/event'); // url to send info
  var result = await https.post(url, body: body);
  print(result.body); // This is for testing purposes only

  // If the login was successful, we can store the login token for future use
  if (result.statusCode == 200) {
    
  }
  else{
     return 'Login Failed';
  }
}
