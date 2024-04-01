import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test_app/models/event_models.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(event.title ?? 'Null title', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            ),
          ],
        ),
    );
  }
}
