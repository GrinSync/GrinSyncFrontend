import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/pages/edit_event_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event; // Event to show details of as a field of the class
  VoidCallback refreshParent;

  EventDetailsPage({required this.event, required this.refreshParent});

  @override
  Widget build(BuildContext context) {
    bool isCreatedByThisUser = (event.host == USER.value?.id) ||
        (ORGIDS.contains(
            event.host)); // Check if the event is created by the current user
    var favorited = ValueNotifier(event
        .isFavorited); // ValueNotifier to store if the event is favorited by the user so that the heart icon can be updated in real time

    // Function to confirm deletion of the event
    // delete the event if confirmed
    // pop the dialog and the page to go back to the previous page
    Future<void> confirmDeletion() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Are you sure you want to delete this event?'),
                ],
              ),
            ),
            actions: <Widget>[
              // Cancel button
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
              // Yes button
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  deleteEvent(event.id); // Call deleteEvent
                  Fluttertoast.showToast(
                      msg: 'Event deleted successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey[800],
                      textColor: Colors.white,
                      fontSize: 16.0);

                  refreshParent(); // Refresh the parent page
                  Navigator.of(context).pop(); // Dismiss the dialog
                  Navigator.of(context).pop(); // Dismiss the page
                },
              ),
            ],
          );
        },
      );
    }
    // actual page
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text('Event Details',
              style: TextStyle(fontWeight: FontWeight.w800)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            // Show favorite button if user is logged in
            if (isLoggedIn())
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ValueListenableBuilder(
                    valueListenable: favorited,
                    builder: (context, value, child) {
                      return value
                          ? Icon(Icons.favorite, color: Colors.white)
                          : Icon(Icons.favorite_border,
                              color: Theme.of(context).colorScheme.primary);
                    }),
              )
          ]),
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 230, 229)),
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                Flexible(
                    child: Text(
                        event.title, // Show the event's title
                        style: const TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 35,
                            fontWeight: FontWeight.bold))),
                const SizedBox(
                  width: 15,
                ),
                if (event.studentsOnly ?? false)
                  Card.outlined(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.lightBlue[400]!, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Students Only",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Helvetica',
                              color: Colors.lightBlue[800])),
                    ),
                  )
              ]),
              // Show information about the event: Host, Location, Starts at, Ends at, Description, Tags
              const Text('Host',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(
                event.hostName.toString(),
                style: const TextStyle(fontSize: 20, fontFamily: 'Helvetica'),
              ),
              const Text('Location',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(event.location,
                  style:
                      const TextStyle(fontSize: 20, fontFamily: 'Helvetica')),
              const Text('Starts at',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(timeFormat(event.start),
                  style:
                      const TextStyle(fontSize: 20, fontFamily: 'Helvetica')),
              const Text('Ends at',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(timeFormat(event.end),
                  style:
                      const TextStyle(fontSize: 20, fontFamily: 'Helvetica')),
              const Text('Description:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                  child: HtmlWidget(event.description, // Show the event's description
                      textStyle: const TextStyle(
                          fontSize: 15, fontFamily: 'Helvetica'),
                ),
                )
              ),
              const Text('Tags:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Wrap(
                children: buildTags(context),
              ),

              // if (event.nextRepeat != null)

              // TO-DO: Nam - Page routing for next recurring event

              // some space
              const SizedBox(height: 50),

              // Buttons from here

              // Like button
              if (isLoggedIn())
                SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder(
                      valueListenable: favorited,
                      builder: (context, value, child) {
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink[400],
                                foregroundColor: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  value
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 20,
                                ),
                                SizedBox(width: 5.0),
                                Text(value ? 'Unsave Event' : 'Save Event'),
                              ],
                            ),
                            onPressed: () {
                              toggleLikeEvent(event.id);
                              event.isFavorited = !event.isFavorited;
                              favorited.value = !favorited.value;
                              Fluttertoast.showToast(
                                  msg: event.isFavorited
                                      ? 'Saved successfully'
                                      : 'Unsaved successfully',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey[800],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            });
                      }),
                ),

              const SizedBox(height: 10),

              // Share button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 172, 28),
                        foregroundColor: Colors.black),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share,
                          size: 20,
                        ),
                        SizedBox(width: 5.0),
                        Text('Share Event'),
                      ],
                    ),
                    onPressed: () {
                      Share.share(
                          'Check out this event: ${event.title} at ${event.location} on ${timeFormat(event.start)}');
                    }),
              ),

              if (isCreatedByThisUser) const SizedBox(height: 10),

              // Edit button
              if (isCreatedByThisUser)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 172, 28),
                          foregroundColor: Colors.black),
                      child: const Text('Edit Event'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    EventEditPage(event: event)));
                      }),
                ),

              if (isCreatedByThisUser) const SizedBox(height: 10),

              // Delete button
              if (isCreatedByThisUser)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white),
                      child: const Text('Delete'),
                      onPressed: () {
                        confirmDeletion(); //pop up a dialog to confirm deletion and delete the event
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to parse the tags of the event and build a list of Card widgets to show the tags
  List<Card> buildTags(BuildContext context) {
    List<Card> allCards = <Card>[]; // List to store the tags as Card widgets

    List<String>? tags = event.tags;

    // // If the tags are not null, split the tags by comma and add each tag as a Card widget to the list
    if (tags != null) {
      List<String> allTags = tags;

      
      // print(allTags); // tags here are already broken

      // For each tag, create a Card widget with the tag as the text
      for (String tag in allTags) {
        allCards.add(Card.outlined(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1.0),
              borderRadius: BorderRadius.circular(5.0)),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(tag,
                style: TextStyle(fontSize: 15, fontFamily: 'Helvetica', color: Colors.red[800])),
          ),
        ));
      }
    }

    return allCards;
  }
}

// Widget buildNextRecurringEventCard(BuildContext context) {

//   Future<List<Event>> allUpcomingEvents = getUpcomingEvents();

//   return Card.outlined(
//                   shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                           color: Theme.of(context).colorScheme.primary,
//                           width: 3.0),
//                       borderRadius: BorderRadius.circular(5.0)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Next recurring event is on ${allUpcomingEvents.singleWhere((element) => element.id == id}",
//                         style: TextStyle(fontSize: 16)),
//                   ),
//                 );
// }
