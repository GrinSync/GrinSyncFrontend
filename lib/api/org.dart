import 'package:flutter_test_app/global.dart';
import 'package:http/http.dart' as http;

Future<dynamic> createOrg(String email, String orgName, String orgCode) async {
  // body stores the username and password in a single map data structure
  Map body = {
    'name': orgName,
    'alias': orgCode,
    'email': email
  };
  var token = BOX.get('token');
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  var url = Uri.parse('https://grinsync.com/api/create/org'); // url to send info
  var result = await http.post(url, headers: headers, body: body);

  if (result.statusCode == 200) {
    return 'Success';
  }
  else{
    print(result.body);
    return null;
  }


} 