import 'dart:convert';

import 'package:flutter_test_app/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

Future userAuthentication(String email, String password) async {
  Map body = {
    email: email,
    password: password,
  };
  var url = Uri.parse('grinsync.com');
  var result = await http.post(url, body: body);
  print(result.body);

  if (result.statusCode == 200) {
    Map json = jsonDecode(result.body);
    String token = json['key'];
    var box = await Hive.openBox(tokenBox);
    box.put('token', token);
  }
}
