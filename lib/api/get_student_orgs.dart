import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/org_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/models/org_models.dart';

class OrgCard extends StatelessWidget {
  const OrgCard({
    super.key,
    required this.org,
    required this.refreshParent,
  });
  final Org org;
  final VoidCallback refreshParent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(org.name,
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold)),
      subtitle: Text(org.email, style: TextStyle(fontSize: 15)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrgDetailsPage(org: org, refreshParent: refreshParent)));
      },
    );
  }
}

Future<void> setStudentOrgs() async {
  clearOrgs(); // clear the lists of student organizations and their ids

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
      // print('jsonOrg: $jsonOrg');
      Org newOrg = Org.fromJson(jsonOrg);
      STUDENTORGS.add(newOrg.name);
      ORGIDS.add(newOrg.id);
    }
  }
}

Future<List<Org>> getUserOrgs() async {
  List<Org> orgs = [];

  var token = BOX.get('token');
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  var url = Uri.parse('https://grinsync.com/api/getUserOrgs');
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

Future<Org?> getOrgById(int id) async {
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
  var url =
      Uri(scheme: 'https', host: 'grinsync.com', path: 'api/getFollowedOrgs');
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

  var url =
      Uri(scheme: 'https', host: 'grinsync.com', path: 'api/toggleFollowedOrg');
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

  var result =
      await http.post(url, headers: headers, body: {'id': id.toString()});

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
