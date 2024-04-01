import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test_app/main.dart';
import 'package:flutter_test_app/models/event_models.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Event Details', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(event.title ?? 'Null title', style: TextStyle(fontFamily: 'Helvetica', fontSize: 30, fontWeight: FontWeight.w800)),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.pink),
                    tooltip: 'Save the event',
                    onPressed: () {
                      // Add event to favorites
                      // setState
                      // implement icon logic (Icons.favorite) if event is in favorites (not in here!)
                    })
                ]
              ),
              Text('Organizer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              TextButton(onPressed: () {
                // leads to User/organization profile page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
              }, 
                child: Text('Org/User Name (Not implemented)'),
                ),
              Text('Event Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(event.location ?? 'Null location', style: TextStyle(fontSize: 20)),
              Text('Event starts at', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(event.startDate ?? 'Null start date', style: TextStyle(fontSize: 20)),
              Text('Event ends at', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(event.endDate ?? 'Null end date', style: TextStyle(fontSize: 20)),
              Text('Event Description:' , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(event.description ?? 'Null description', style: TextStyle(fontSize: 16)),
                ),
                color: Colors.grey[200],
              ),
            ],
          ),
        ),
    );
  }
}
