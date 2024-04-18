import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/guest_event_creation_page.dart';
import 'package:flutter_test_app/pages/user_event_creation_page.dart';
import 'package:flutter_test_app/global.dart';

class CreatePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
          if (GUESTMODE) {
            return GuestEventCreationPage();
          } else {
            return const EventCreationPage();
          }
        }
  }
