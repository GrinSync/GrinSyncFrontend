import 'dart:convert';

import 'package:flutter_test_app/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

Future userAuthentication(String username, String password) async {
  // body stores the username and password in a single map data structure
  Map body = {
    'username': username,
    'password': password,
  };
  var url = Uri.parse('https://grinsync.com/api/auth'); // url to send info
  var result = await http.post(url, body: body);
  print(result.body); // This is for testing purposes only

  // If the login was successful, we can store the login token for future use
  if (result.statusCode == 200) {
    Map json = jsonDecode(result.body);
    String token = json['token'];
    var box = await Hive.openBox(tokenBox);
    // TODO: Encrypt this box!
    box.put('token', token); // save token in box
    box.close();
    await getUser(token);
  } else {
    return 'Login Failed';
  }
}

getUser(String token) async {
  var url = Uri.parse('http://grinsync.com/api/getUser'); // url to send info
  var res = await http.get(url, headers: {
    'Authorization': 'Token $token',
  });
  print(res.body);
}
