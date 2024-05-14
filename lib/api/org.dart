import 'package:grinsync/global.dart';
import 'package:http/http.dart' as http;

/// Function to create pass information to backend to create a student org
Future<dynamic> createOrg(String email, String orgName, String orgCode) async {
  // body stores the org name, org alias, and email in a single map data structure
  Map body = {'name': orgName, 'alias': orgCode, 'email': email};
  var token = BOX.get('token'); // Get the users token
  Map<String, String> headers;
  if (token == null) {
    // If no token, do not pass a token to the backend
    headers = {};
  } else {
    // If token exists, store it in this header map to pass to backend
    headers = {'Authorization': 'Token $token'};
  }
  var url =
      Uri.parse('https://grinsync.com/api/create/org'); // url to send info
  var result = await http.post(url, headers: headers, body: body);

  if (result.statusCode == 200) {
    return 'Success'; // Return Success if org was created successfully
  } else {
    return null; // Return null if org was not created
  }
}
