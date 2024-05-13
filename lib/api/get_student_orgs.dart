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
          style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold)),
      subtitle: Text(org.email, style: const TextStyle(fontSize: 15)),
      // Navigates to the Org Details page when the user taps on the card
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

/// Clears student organizations when the users log out
clearOrgs() {
  // Clears the global variable for student organizations and their IDs
  STUDENTORGS.clear();
  ORGIDS.clear();
}

/// Gets the list of student organizations that the current user follows
Future<List<Org>> getFollowedOrgs() async {
  List<Org> followedOrgs = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all student organizations followed by the current user from the server
  var url = Uri.parse('https://grinsync.com/api/getFollowedOrgs');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of Org objects
  // result.body is a list of maps with org information
  for (var jsonOrg in jsonDecode(result.body)) {
    followedOrgs.add(Org.fromJson(jsonOrg));
  }

  return followedOrgs;
}

/// Gets a student organization by ID
Future<Org?> getOrgById(int id) async {
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets the student organization whose ID matches the argument
  var url = Uri.parse('https://grinsync.com/api/getOrg?id=$id');
  var result = await http.get(url, headers: headers);

  if (result.statusCode == 200) {
    return Org.fromJson(jsonDecode(result.body));
  } else {
    return null;
  }
}

/// Gets the list of all student orgs led by the current user
Future<List<Org>> getUserOrgs() async {
  List<Org> userOrgs = [];
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all student organizations led by the current user from the server
  var url = Uri.parse('https://grinsync.com/api/getUserOrgs');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of Org objects
  // result.body is a list of maps with org information
  for (var jsonOrg in jsonDecode(result.body)) {
    userOrgs.add(Org.fromJson(jsonOrg));
  }

  return userOrgs;
}

/// Sets the list of all student orgs led by the current user by modifying the global variable
Future<void> setStudentOrgs() async {
  // Clears the lists of student organizations and their ids
  clearOrgs();

  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all student organizations led by the current user from the server
  var url = Uri.parse('https://grinsync.com/api/getUserOrgs');
  var result = await http.get(url, headers: headers);

  // parse the json response and sets the list of student organizations via the global variables
  // result.body is a list of maps with org information (after jsonDecoding)
  if (jsonDecode(result.body) is Iterable){
    for (var jsonOrg in jsonDecode(result.body)) {
      Org newOrg = Org.fromJson(jsonOrg);
      STUDENTORGS.add(newOrg.name);
      ORGIDS.add(newOrg.id);
    }
  }
}

/// Toggles a followed student organization by ID
Future<void> toggleFollowedOrg(int id) async {
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Toggles the followed student organization whose ID matches the argument
  var url = Uri.parse('https://grinsync.com/api/toggleFollowedOrg');
  var result =
      await http.post(url, headers: headers, body: {'id': id.toString()});

  if (result.statusCode == 200) {
    // print('Org followed/unfollowed');
  } else {
    // print(result.body);
  }
}

/// Unfollows a student organization by ID
Future<void> unfollowOrg(int id) async {
  // Gets the authorization token for the current user
  var token = BOX.get('token');
  Map<String, String> headers;
  // Populates the header of the HTTP call with the token
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Unfollows the student organization whose ID matches the argument
  var url = Uri.parse('https://grinsync.com/api/unfollowOrg');
  var result =
      await http.post(url, headers: headers, body: {'id': id.toString()});

  if (result.statusCode == 200) {
    // print('Org unfollowed');
  } else {
    // print(result.body);
  }
}
