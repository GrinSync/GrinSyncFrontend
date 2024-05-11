import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/global.dart';
import 'package:http/http.dart' as http;

class ConnectOrgPage extends StatefulWidget {
  const ConnectOrgPage({super.key});
  @override
  State<ConnectOrgPage> createState() => _ConnectOrgPage();
}

class _ConnectOrgPage extends State<ConnectOrgPage> {
  /// Initializes empty list of orgs
  late List<String> allOrgs = <String>[];
  String? data = ''; // String to hold connected orgs name

  Future<void> loadOrgs() async {
    allOrgs = await getAllOrgs(); // function to get all created orgs
  }

  /// Initialize Connect Org page
  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  /// Build the Connect Org Page interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Organization',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: loadOrgs(),
          builder: (context, snapshot) {
            // if the connection is waiting, show a loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      'Preparing orgs for you...',
                    ),
                  ],
                ),
              );
              // if there is an error, show an error message and a button to try again
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading student orgs'),
                    TextButton(
                      onPressed: () {
                        getAllOrgs();
                        setState(() {});
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
              // if the connection is done, show the events
            } else {
              // if there are no orgs, show a message
              if (allOrgs.isEmpty) {
                return const Center(
                  child: Text("No Student Orgs exist"),
                );
                // if there are events, show the events
              } else {
                return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        // Arrange children vertically.
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownSearch<String>(
                            items: allOrgs,
                            onChanged: (String? stuff) {
                              data = stuff;
                            },
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 200,
                                height: 50,
                                // Create Org Creation Button
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 218, 41, 28),
                                        foregroundColor: Colors.black),
                                    onPressed: () async {
                                      // Get id of selected student org
                                      int id = await getId(data);
                                      // Connect Student Org
                                      var auth = await connectOrg(id);
                                      if (auth == 'Success') { // If 'Success' is returned, Org was connected!
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Connect to Org')),
                              ))
                        ]));
              }
            }
          }),
    );
  }
}

/// Function that returns all student orgs
Future<List<String>> getAllOrgs() async {
  var token = BOX.get('token'); // Get token from tokenbox
  List<String> allOrgs = []; // Initialize list to store student orgs
  Map<String, String> headers;
  if (token == null) { // If there is no token, do not pass one to the backend
    headers = {};
  } else {
    // If token exists, store it in this header map to pass to backend
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/getAllOrgs'); // url to send info to
  var result = await http.get(url, headers: headers);

  // parse the json response and create a list of all orgs
  for (var org in jsonDecode(result.body)) {
    allOrgs.add(org['name']);
  }
  return allOrgs; // return a list of all orgs
}

/// Function that takes in org's name and returns its id
Future<int> getId(String? data) async {
  var token = BOX.get('token'); // Get token from tokenbox
  Map<String, String> headers;
  if (token == null) { // If there is no token, do not pass one to the backend
    headers = {};
  } else {
    // If token exists, store it in this header map to pass to backend
    headers = {'Authorization': 'Token $token'};
  }
  int id = 0; // Variable to hold org id
  var url = Uri.parse('https://grinsync.com/api/getAllOrgs');
  var result = await http.get(url, headers: headers);

// parse the json response and create a list of all orgs
  for (var org in jsonDecode(result.body)) {
    if (org['name'] == data) {
      id = org['id']; // Save org id
    }
  }
  return id; // Return org id
}

/// Function that connects a user to the corresponding org given by the passed id
Future<String> connectOrg(int id) async {
  var token = BOX.get('token'); // Get token from tokenbox
  Map<String, String> headers;
  if (token == null) { // If there is no token, do not pass one to the backend
    headers = {};
  } else {
    // If token exists, store it in this header map to pass to backend
    headers = {'Authorization': 'Token $token'};
  }
  String identity = id.toString(); // Save id as a string
  Map body = {
    'id': identity,
  };
  var url = Uri.parse('https://grinsync.com/api/claimOrg'); // url to send info to
  var result = await http.post(url, headers: headers, body: body);
  if (result.statusCode == 200) { // If connection succeeded, return 'Success'
    return 'Success';
  }
  return 'Error'; // If connecting org failed, return 'Error'
}
