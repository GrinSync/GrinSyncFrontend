import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/constants.dart';

var BOX;

ValueNotifier<User?> USER = ValueNotifier<User?>(null); //please don't change this variable manually; always use setLoginStatus() to change this variable; when you want to access the current user, use USER.value

String ALLTAGS = ''; // this will be a string of all tags separated by commas