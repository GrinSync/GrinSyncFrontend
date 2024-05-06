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


Future<List<Org>> getFollowedOrgs() async {
  List<Org> orgs = [];
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  var url = Uri(
    scheme: 'https',
    host: 'grinsync.com',
    path: 'api/getFollowedOrgs');
  var result = await http.get(url, headers: headers);

  if (result.statusCode == 200) {
    for (var jsonOrg in jsonDecode(result.body)) {
      orgs.add(Org.fromJson(jsonOrg));
    }
    return orgs;
  } else {
    return [];
  }
}

Future<void> toggleFollowedOrg(int id) async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri(
    scheme: 'https',
    host: 'grinsync.com',
    path: 'api/toggleFollowedOrg');
  var result =
      await http.post(url, headers: headers, body: {'id': id.toString()});

  if (result.statusCode == 200) {
    print('Org followed/unfollowed');
  } else {
    print(result.body);
  }
}

Future<void> unfollowOrg(int id) async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri(
    scheme: 'https',
    host: 'grinsync.com',
    path: 'api/unfollowOrg',  
  );

  var result = await http.post(url, headers: headers, body: {'id': id.toString()});

  if (result.statusCode == 200) {
    print('Org unfollowed');
  } else {
    print(result.body);
  }
}

// performed at times such as logging out
clearOrgs() {
  STUDENTORGS.clear();
  ORGIDS.clear();
}