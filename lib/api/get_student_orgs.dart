import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/models/org_models.dart';

Future<void> setStudentOrgs() async {

  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
    var url = Uri.parse('https://grinsync.com/api/getUserOrgs');
    var result = await http.get(url, headers: headers);

    // result.body is a list of maps with int'id', String'name', String'email', String'description', Bool'is_active', 'last_login', String'password', List<int>'studentLeaders' (after jsonDecoding)
    // for (var jsonOrg in jsonDecode(result.body)) {
    //   STUDENTORGS.add(jsonOrg['name']);
    //   ORGIDS.add(jsonOrg['id']);
    // }
    for (var jsonOrg in jsonDecode(result.body)) {
      print('jsonOrg: $jsonOrg');
      Org newOrg = Org.fromJson(jsonOrg);
      STUDENTORGS.add(newOrg);
      ORGIDS.add(newOrg.id!);
    }
  }
}

Future<Org?> getOrgById (int id) async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/getOrg?id=$id');
  var result = await http.get(url, headers: headers);

  print('getOrgById result: ${result.body}');

  if (result.statusCode == 200) {
    return Org.fromJson(jsonDecode(result.body));
  } else {
    return null;
  }
  
}

// performed at times such as logging out
clearOrgs() {
  STUDENTORGS.clear();
  ORGIDS.clear();
}