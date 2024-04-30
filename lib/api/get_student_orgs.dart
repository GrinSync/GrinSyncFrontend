import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/global.dart';



Future<void> setStudentOrgs() async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
    var url = Uri.parse('https://grinsync.com/api/getUserOrgs');
  var result = await http.get(url, headers: headers);

  // result.body is a list of maps with 'id', 'name', 'email', 'description', 'is_active', 'last_login', 'password', 'studentLeaders' (after jsonDecoding)
  for (var jsonOrg in jsonDecode(result.body)) {
    STUDENTORGS.add(jsonOrg['name']);
    ORGIDS.add(jsonOrg['id']);
  }
  }
 
}