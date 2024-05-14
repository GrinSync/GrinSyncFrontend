import 'dart:convert';
import 'package:flutter_test_app/api/get_student_orgs.dart';
import 'package:flutter_test_app/api/tags.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/registration_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  // If the login was successful, we can store the login token for future use
  if (result.statusCode == 200) {
    Map json = jsonDecode(result.body);
    String token = json['token'];
    BOX.put('token', token); // save token in box
    User? user =
        await getUser(token); // Get the user now that we have logged in

    // initialize the preferred tags and student orgs
    await setPrefferedTags();
    await setStudentOrgs();

    return user; // Return the user
  } else {
    return 'Login Failed';
  }
}

/// Get the user given the users token
Future<User?> getUser(String token) async {
  var url = Uri.parse('https://grinsync.com/api/getUser'); // url to send info
  var res = await http.get(url, headers: {'Authorization': 'Token $token'});
  if (res.statusCode == 200) {
    // If getting user succeeded
    var json = jsonDecode(res.body);
    User user = User.fromJson(json); // Save user
    user.token = token;
    return user; // Return the user
  } else {
    return null;
  }
}

/// Set login status based on if the user is logged in, if the user is logged in,
/// set USER to the current user, if the user is not logged in, set USER to null
Future<void> setLoginStatus() async {
  var token = BOX.get('token'); // Get the token
  if (token == null) {
    // If there is no token, the user is not logged in, so do not get a user
    USER.value = null;
  } else {
    // If a token exists, get the user
    USER.value = await getUser(token);
  }
}

/// check if the user is logged in
bool isLoggedIn() {
  return USER.value != null;
}

/// Register the user
Future<dynamic> registerUser(String firstName, String lastName, String email,
    String password, String confirmPassword, SingingCharacter? accType) async {
  String account;
  switch (accType) {
    // Check the account type of the user
    case SingingCharacter.student:
      account = 'STU';
    case SingingCharacter.faculty:
      account = 'FAL';
    case SingingCharacter.community:
      account = 'COM';
    case null:
      account = 'COM';
  }

  /// Store the user data in a map to pass to the backend
  Map<String, String> data = {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'type': account
  };

  // Check that both password fields are equal
  if (confirmPassword != password) {
    return null;
  }
  var url =
      Uri.parse('https://grinsync.com/api/create/user'); // url to send info
  var res = await http.post(url, body: data);
  if (res.statusCode == 200) {
    return 'Login Success'; // Return success if account was created successfully
  } else {
    return null; // Return null if account creation failed
  }
}

/// Calling this function logs the user out
Future<void> logout() async {
  BOX.delete('token'); // save token in box
  setLoginStatus(); // sets the global variable USER to null
  clearPrefferedTags(); // clears the preferred tags
  clearOrgs(); // clears the student orgs

  // show a message
  Fluttertoast.showToast(
    msg: "You are successfully logged out",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
  );
}

/// Return the user by their user ID
Future<User?> getUserByID(int id) async {
  var token = BOX.get('token'); // Get the user token
  // Map to hold token to pass to backend
  Map<String, String> headers;
  if (token == null) {
    // If token is null, do not pass it to the backend
    headers = {};
  } else {
    // If there is a token, store it in this map
    headers = {'Authorization': 'Token $token'};
  }

  var url = Uri.parse('https://grinsync.com/api/getUser?id=$id');
  var result = await http.get(url, headers: headers);
  if (result.statusCode == 200) {
    // Getting user succeeded, store user
    return User.fromJson(jsonDecode(result.body));
  } else {
    // If getting user failed, return null;
    return null;
  }
}
