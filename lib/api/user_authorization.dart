import 'dart:convert';

import 'package:flutter_test_app/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;


Future userAuthentication(String username, String password) async {
  Map body = {
    'username': username,
    'password': password,
  };
  var url = Uri.parse('http://grinsync.com/api/auth');
  //var stuff = http.get(url);
  //final csrfToken = await getCsrfToken();
  var result = await http.post(url, body: body);
  print(result.body);
  Map json = jsonDecode(result.body);
  if (json.containsKey("non_field_errors")){
    return 'yum';
  }
  if (result.statusCode == 200) {
    Map json = jsonDecode(result.body);
    String token = json['token'];
    var box = await Hive.openBox(tokenBox);
    box.put('token', token);
    box.close();
  }
}
