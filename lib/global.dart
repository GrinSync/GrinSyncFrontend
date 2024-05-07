import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/models/org_models.dart';

var BOX;

ValueNotifier<User?> USER = ValueNotifier<User?>(
    null); //please don't change this variable manually; always use setLoginStatus() to change this variable; when you want to access the current user, use USER.value

final List<String> ALLTAGS =
    []; // this will be a string of all tags separated by commas
List<String> PREFERREDTAGS =
    []; // this will be a string of all preferred tags separated by commas
// important: if you are will use the PREFERREDTAGS variable, make sure to use getPreferredTags() and getAllTags() functions in tags.dart
// if you do yourList = PREFERREDLIST, you could be modifying the global variable unintentionally (learned from real experience ;_;)

List<String> STUDENTORGS =
    []; // this list will contain student org names that the user is linked with
List<int> ORGIDS =
    []; // this list will contain student org ids that the user is linked with
