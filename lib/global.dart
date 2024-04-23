import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/user_models.dart';

ValueNotifier<User?> USER = ValueNotifier<User?>(null); //please don't change this variable manually; always use setLoginStatus() to change this variable; when you want to access the current user, use USER.value
