import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter/material.dart';

void main () {
  // late Event testEvent;
  // late EventCardFavoritable testEventCardFavoritable;
  var eventInfo = [{'title' : 'Test Event',
                    'id' : 1,
                    'hostName' : 'Kevin',
                    'description' : 'This is a test event',
                    'start' : '2024-04-20T11:09:00-05:00',
                    'end' : '2024-04-20T12:09:00-05:00',
                    'location' : 'Test Location',
                    'tags' : '',
                    'isFavorited' : false, 
                    'host' : 1,
                    'nextRepeat' : null,
                    'studentsOnly' : false
                    }, 
                    {
                    'title' : 'Test Event 2',
                    'hostName' : 'Kevin2',
                    'description' : 'This is a test event 2',
                    'start' : null,
                    'end' : null,
                    'location' : 'Test Location 2',
                    'tags' : '',
                    'isFavorite' : true,},
                    {
                    }, {}];

  // setUp(() {
    // Add setup code that will be run before each test

    // testEvent = Event(
    //   title: 'Test Event',
    //   hostName: 'Kevin',
    //   description: 'This is a test event',
    //   start: '10:00:00',
    //   end: '12:00:00',
    //   location: 'Test Location',
    //   tags: ''
    // );

    // testEventCardFavoritable = EventCardFavoritable(event: testEvent);

  // });

//   testWidgets('Test saving an event', (WidgetTester tester) async {
//     // Create the widget by telling the tester to build it.
//     await tester.pumpWidget(EventCardFavoritable(event: Event.fromJson(eventInfo[0])));

//     // Check that there is a favorite border icon
//     expect(find.byIcon(Icons.favorite), 0);
//     expect(find.byIcon(Icons.favorite_border), 1);

//     // Tap the heart icon and trigger a rebuild
//     await tester.tap(find.byIcon(Icons.favorite_border));
//     await tester.pump();

//     // Check that there is a favorite icon
//     expect(find.byIcon(Icons.favorite), 1);
//     expect(find.byIcon(Icons.favorite_border), 0);
//   });

}