import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/global.dart';

Future<void> getStudentOrgs() async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  print(headers);

  var url = Uri.parse('https://grinsync.com/api/getUserOrgs');
  var result = await http.get(url, headers: headers);
  
  // parse the json response and create a string of all tags with commas in between
  // result.body is a list of maps with tag names, ids, and selectDefault values (after jsonDecoding)
  for (var jsonTag in jsonDecode(result.body)) {
    STUDENTORGS.add(jsonTag['name']);
  }
}