import 'dart:convert';
import 'package:flutter_test_app/constants.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/registration_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test_app/global.dart';

Future<dynamic> userAuthentication(String username, String password) async {
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
    User? user = await getUser(token);
    return user;
  } else {
    return 'Login Failed';
  }
}

Future<User?> getUser(String token) async {
  var url = Uri.parse('https://grinsync.com/api/getUser'); // url to send info
  var res = await http.get(url, headers: {'Authorization': 'Token $token'});
  print(res.body);
  if (res.statusCode == 200) {
    var json = jsonDecode(res.body);
    User user = User.fromJson(json);
    user.token = token;
    return user;
  } else {
    return null;
  }
}

  // check if the user is logged in, 
  // if the user is logged in, set GUESTMODE to false, and set USER to the current user
  // if the user is not logged in, set GUESTMODE to true, and set USER to null
  Future<void> setLoginStatus() async {
    var box = await Hive.openBox(tokenBox);
    var token = box.get('token');
    box.close();
    if (token == null) {
      USER.value = null;
    } else {
      USER.value = await getUser(token);
    }
  }

Future<dynamic> registerUser(String firstName, String lastName, String email,
    String password, SingingCharacter? accType) async {
  String account;
  switch (accType) {
    case SingingCharacter.student:
      account = 'STU';
    case SingingCharacter.faculty:
      account = 'FAL';
    case SingingCharacter.community:
      account = 'COM';
    case null:
      account = 'COM';
  }
  Map<String, String> data = {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'type': account
  };
  var url =
      Uri.parse('https://grinsync.com/api/create/user'); // url to send info
  var res = await http.post(url, body: data);
  print(res.body);
  if (res.statusCode == 200) {
    //var json = jsonDecode(res.body);
    // String token = json['key'];
    // var userAttempt = await getUser(token);
    // if (userAttempt != null) {
    //   User user = userAttempt;
    //   return user;
    // } else {
    //   return null;
    // }
    return 'Login Success';
  } else {
    return null;
  }
}

// Calling this function logs the user out
Future<void> logout() async {
  var box = await Hive.openBox(tokenBox);
  box.delete('token'); // save token in box
  // box.close(); //box will be closed in setLoginStatus
  setLoginStatus(); // sets the global variable USER to null

  // show a message
  Fluttertoast.showToast(
    msg: "You are successfully logged out",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
  );
}

Future<dynamic> passwordReset(String email) async {
  // body stores the username and password in a single map data structure
  Map body = {
    'username': email,
  };
  var url =
      Uri.parse('https://grinsync.com/api/password_reset/'); // url to send info
  var result = await http.post(url, body: body);
  print(result.body); // This is for testing purposes only
}
