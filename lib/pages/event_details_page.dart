import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;


  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    var favorited = ValueNotifier(event.isFavoited);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Event Details',
            style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [], //TODO: Add edit button and delete button if user is the organizer
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              Flexible(
                  child: Text(event.title ?? 'Null title',
                      style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 30,
                          fontWeight: FontWeight.w800))),
              if (isLoggedIn()) //only shows the like button when the user is logged in
                ValueListenableBuilder(
                  valueListenable: favorited,
                  builder: (context, value, child) {
                    return IconButton(
                        icon: value? const Icon(Icons.favorite, color: Colors.pink):Icon(Icons.favorite_border, color: Colors.pink),
                        tooltip: value? 'Unsave the event':'Save the event',
                        onPressed: () {
                          toggleLikeEvent(event.id);
                          event.isFavoited = !value;
                          favorited.value = !value;
                        });
                  }
                )
            ]),
            Text('Organizer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            TextButton(
              onPressed: () {
                // leads to User/organization profile page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
              },
              child: Text('Org/User Name (Not implemented)'),
            ),
            //Text('Event Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            //Text(event.location ?? 'Null location', style: TextStyle(fontSize: 20)),
            Text('Event starts at',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text(event.start ?? 'Null start date',
                style: TextStyle(fontSize: 20)),
            Text('Event ends at',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text(event.end ?? 'Null end date', style: TextStyle(fontSize: 20)),
            Text('Event Description:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(event.description ?? 'Null description',
                    style: TextStyle(fontSize: 16)),
              ),
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
