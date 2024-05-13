import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/global.dart';

/// Sets the list of all tags by modifying the global variable
Future<void> setAllTags() async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  // Gets all the tags from the server
  var url = Uri.parse('https://grinsync.com/api/getAllTags');
  var result = await http.get(url, headers: headers);

  // Parses the json response and creates a string of all tags with commas in between
  // result.body is a list of maps with tag names, ids, and selectDefault values (after jsonDecoding)
  for (var jsonTag in jsonDecode(result.body)) {
    ALLTAGS.add(jsonTag['name']);
  }
}

/// Sets the list of preferred tags by modifying the global variable
Future<void> setPrefferedTags() async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    // If the user is not logged in, set the preferred tags to all tags
    PREFERREDTAGS = getAllTags();
  } else {
    // If the user is logged in, get the list of preferred tags from the server
    headers = {'Authorization': 'Token $token'};
    var url = Uri.parse('https://grinsync.com/api/getUserTags');
    var result = await http.get(url, headers: headers);

    // Parses the json response and creates a string of all tags with commas in between
    // result.body is a list of maps with tag names, ids, and selectDefault values (after jsonDecoding)
    for (var jsonTag in jsonDecode(result.body)) {
      PREFERREDTAGS.add(jsonTag['name']);
    }
  }
}

/// Updates the user's preferred tags
Future<void> updatePrefferedTags(selectedTags) async {
  var token = BOX.get('token');

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/updateInterestedTags');
  await http.post(url,
      headers: headers,
      body: {'tags': selectedTags.isEmpty ? '' : selectedTags.join(';')});
}

/// Gets a list of all tags as a list of string separated by commas
getAllTags() {
  return List<String>.from(ALLTAGS);
}

/// Gets a list of preferred tags as a list of string separated by commas
getPreferredTags() {
  return List<String>.from(PREFERREDTAGS);
}

/// Clears the list of preferred tags by clearing the global variable
clearPrefferedTags() {
  PREFERREDTAGS.clear();
}
