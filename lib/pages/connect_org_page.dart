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
  /// Initializes empty list of event
  late List<String> allOrgs = <String>[];
  String? data = '';

  Future<void> loadOrgs() async {
    allOrgs = await getAllOrgs(); // function in get_events.dart
  }

  /// Initialize variables to store email and password for the login page
  @override
  void initState() {
    super.initState();
  }

  /// Dispose of the email and password when page closes.
  @override
  void dispose() {
    super.dispose();
  }

  /// Build the Login Page interface
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
              // if there are no events, show a message
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
                          backgroundColor:
                              const Color.fromARGB(255, 218, 41, 28),
                          foregroundColor: Colors.black),
                      onPressed: () async {
                        // Authorize user with provided credentials
                        int id = await getId(data);
                        var auth = await connectOrg(id);
                        if (auth == 'Success'){
                             Navigator.of(context).pop();
                        }
                          else{
                        }
                      },
                      child: const Text('Connect to Org')),
                ))
                    ]
                    )
                    );
              }
            }
          }),
    );
  }
}

Future<List<String>> getAllOrgs() async {
  var token = BOX.get('token');
  List<String> allOrgs = [];
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/getAllOrgs');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a string of all tags with commas in between
  // result.body is a list of maps with tag names, ids, and selectDefault values (after jsonDecoding)
  for (var jsonTag in jsonDecode(result.body)) {
    allOrgs.add(jsonTag['name']);
  }
  return allOrgs;
}

Future<int> getId(String? data) async {
  var token = BOX.get('token');
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  int id = 0;
  var url = Uri.parse('https://grinsync.com/api/getAllOrgs');
  var result = await http.get(url, headers: headers);
  //print(result.body);
  // parse the json response and create a string of all tags with commas in between
  // result.body is a list of maps with tag names, ids, and selectDefault values (after jsonDecoding)
  for (var jsonTag in jsonDecode(result.body)) {
    if(jsonTag['name'] == data){
      id = jsonTag['id'];
    }
  }
  return id;
}


Future<String> connectOrg(int id) async {
  var token = BOX.get('token');
  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  String identity = id.toString();
  Map body = {
    'id': identity,
  };
  var url = Uri.parse('https://grinsync.com/api/claimOrg');
  var result = await http.post(url, headers: headers, body :body);
  print(result.body);
  if(result.statusCode == 200){
    return 'Success';
  }
  return 'Error';

}
