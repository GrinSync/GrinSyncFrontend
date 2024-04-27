import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/constants.dart';


Future<void> setAllTags() async {
  var box = await Hive.openBox(tokenBox);
  var token = box.get('token');
  box.close();

  Map<String, String> headers;
  if (token == null) {
    headers = {};
  } else {
    headers = {'Authorization': 'Token $token'};
  }
  
  var url = Uri.parse('https://grinsync.com/api/getTags');
  var result = await http.get(url, headers: headers);

  // parse the json response and create a string of all tags with commas in between
  // result.body is a list of maps with tag names, ids, and selectDefault values (after jsonDecoding)
  for (var jsonTag in jsonDecode(result.body)) {
    ALLTAGS += jsonTag['name'] + ',';
  }
}