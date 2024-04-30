import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/global.dart';

Future<void> setAllTags() async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  print(headers);

  var url = Uri.parse('https://grinsync.com/api/getAllTags');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a string of all tags with commas in between
  // result.body is a list of maps with tag names, ids, and selectDefault values (after jsonDecoding)
  for (var jsonTag in jsonDecode(result.body)) {
    ALLTAGS.add(jsonTag['name']);
  }

  // print(ALLTAGS);
}

Future<void> setPrefferedTags() async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    // if the user is not logged in, set the preferred tags to all tags
    // headers = {};
    PREFERREDTAGS = ALLTAGS;
  } else {
    // if the user is logged in, get the preferred tags from the server
    headers = {'Authorization': 'Token $token'};
    var url = Uri.parse('https://grinsync.com/api/getUserTags');
    var result = await http.get(url, headers: headers);

    // parse the json response and create a string of all tags with commas in between
    // result.body is a list of maps with tag names, ids, and selectDefault values (after jsonDecoding)
    for (var jsonTag in jsonDecode(result.body)) {
      PREFERREDTAGS.add(jsonTag['name']);
    }
  }
}

// Update the preferred tags of the user
Future<void> updatePrefferedTags(selectedTags) async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/updateInterestedTags');
  var result = await http.post(url,
      headers: headers,
      body: {'tags': selectedTags.isEmpty ? '' : selectedTags.join(';')});

  //   if (result.statusCode == 200) {
  //   print('Tag Preferences Updated');
  // } else {
  //   print('Failed to update tag preferences');
  // }
}

getAllTags() {
  return List<String>.from(ALLTAGS);
}

getPreferredTags() {
  return List<String>.from(PREFERREDTAGS);
}

clearPrefferedTags() {
  PREFERREDTAGS.clear();
}