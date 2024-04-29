import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/constants.dart';

var BOX;

ValueNotifier<User?> USER = ValueNotifier<User?>(null); //please don't change this variable manually; always use setLoginStatus() to change this variable; when you want to access the current user, use USER.value

List<String> ALLTAGS = []; // this will be a string of all tags separated by commas
List<String> PREFERREDTAGS = []; // this will be a string of all preferred tags separated by commas