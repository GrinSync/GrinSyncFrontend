import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grinsync/api/get_student_orgs.dart';
import 'package:grinsync/api/save_event_to_calendar.dart';
import 'package:grinsync/api/user_authorization.dart';
import 'package:grinsync/models/event_models.dart';
import 'package:grinsync/api/get_events.dart';
import 'package:grinsync/global.dart';
import 'package:grinsync/models/org_models.dart';
import 'package:grinsync/pages/edit_event_page.dart';
import 'package:grinsync/pages/org_details_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:grinsync/api/launch_url.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event; // Event to show details of as a field of the class
  final VoidCallback refreshParent; // Function to refresh the parent page
  const EventDetailsPage(
      {super.key, required this.event, required this.refreshParent});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Event event; // Event field to store the event to show details of

  @override
  void initState() {
    event = widget
        .event; //initialize the event field with the event passed to the class
    super.initState();
  }

  /// Function to refresh the event details page by getting the event by its ID again
  refresh() async {
    var newEvent = await getEventByID(event.id);
    setState(() {
      if (newEvent != null) {
        event = newEvent;
      }
    });
    widget
        .refreshParent(); // if this refreshes, the parent page should refresh too
  }

  @override
  Widget build(BuildContext context) {
    bool isCreatedByThisUser = (event.hostID == USER.value?.id) ||
        (ORGIDS.contains(event
            .parentOrg)); // Check if the event is created by the current user or an organization the user is a part of
    var favorited = ValueNotifier(event
        .isFavorited); // ValueNotifier to store if the event is favorited by the user so that the heart icon can be updated in real time
    bool navigationAvailable = event.latitude != null &&
        event.longitude !=
            null; // Check if the event has a location to navigate to


    /// Function to confirm claiming an event. It sents a verification email to the host email if confirmed.
    Future<void> confirmClaim() async {
      return showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Claim this event'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('This event is scheduled by ${event.contactEmail}. Please only claim this event if you are the host. A verification email will be sent to the email address. Please follow the instructions in the email to claim this event.'),
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
                child: const Text('Send vefification email'),
                onPressed: () async {
                  String msg = await claimEvent(event
                      .id); // Call deleteEvent to delete the event from the backend
                  // Show a toast message to confirm deletion
                  Fluttertoast.showToast(
                      msg: msg,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey[800],
                      textColor: Colors.white,
                      fontSize: 16.0);

                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }

    /// Function to confirm deletion of the event. It delets the event if confirmed.
    Future<void> confirmDeletion() async {
      return showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
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
                onPressed: () async {
                  String deleteMsg = await deleteEvent(event
                      .id); // Call deleteEvent to delete the event from the backend
                  // Show a toast message to confirm deletion
                  Fluttertoast.showToast(
                      msg: deleteMsg,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey[800],
                      textColor: Colors.white,
                      fontSize: 16.0);

                  Navigator.of(context).pop(); // Dismiss the dialog
                  Navigator.of(context).pop(); // Dismiss the page

                  widget.refreshParent(); // Refresh the parent page
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
                          ? const Icon(Icons.favorite, color: Colors.white)
                          : Icon(Icons.favorite_border,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary); // Since the app bar is of the same color, show the heart icon in primary color makes it invisible
                    }),
              ),
            // information button to pop up a dialog with information about the page
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Event Details Page'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                                'This page shows the detailed information of an event.\n'),
                            Text('Information',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                '- You can view the event\'s title, host, location, start and end time, description, and tags.'),
                            Text(
                                '- You can also navigate to the event\'s venue on Google Maps if the location is provided (Indicated by a location pin icon before the location).\n'),
                            Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                'You can save the event to your calendar, contact the host, and share the event with your friends.'),
                            Text(
                                'If you are logged in: You can also favorite the event.'),
                            Text(
                                'If this event is from the college calendar: You can claim the event as yours to make edits (edits will not be reflected on the calendar or 25 Live).'),
                            Text(
                                'If you are the host of the event: You can edit the event or delete it.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ]),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 235, 230, 229)),
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                // Show the event title
                Flexible(
                    child: Text(event.title,
                        style: const TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 35,
                            fontWeight: FontWeight.bold))),
                const SizedBox(
                  width: 15,
                ),
                // Show the 'studentOnly' chip if the event is for students only
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
              InkWell(
                // Show the host name as a clickable link
                child: Text(
                  event.hostName.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Helvetica',
                      decoration: TextDecoration.underline),
                ),
                onTap: () async {
                  // If the host is Grinnell Calendar, open the Grinnell Calendar page
                  if (event.hostName.toString() == "Grinnell Calendar") {
                    launchUrl(Uri.parse("https://events.grinnell.edu/"));
                  } else if (event.parentOrg != null) {
                    // If the host is an organization, open the organization details page
                    Org? org = await getOrgById(event.parentOrg!);
                    if (org != null) {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => OrgDetailsPage(
                                  org: org, refreshParent: () {})));
                    }
                  }
                },
              ),
              const Text('Location',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Wrap(
                children: [
                  InkWell(
                      // Show the location as a clickable link
                      child: Text(event.location,
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Helvetica',
                              color: Colors.black,
                              decoration: TextDecoration.underline)),
                      onTap: () async {
                        if (navigationAvailable) {
                          await MapUtils.launchGoogleMaps(
                              double.parse(event.latitude!),
                              double.parse(event.longitude!));
                        } else {
                          await urlLauncher(Uri.parse(
                              'https://map.concept3d.com/?id=1232#!ct/68846,74074?sbc/'));
                        }
                      }),
                  if (navigationAvailable)
                    const Icon(Icons.location_on, color: Colors.blue),
                ],
              ),
              // Show the start and end time of the event
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

              // Show the description of the event
              const Text('Description',
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
                    // wrapped in HtmlWidget to parse the HTML description
                    child: HtmlWidget(
                      event.description, // Show the event's description
                      textStyle: const TextStyle(
                          fontSize: 15, fontFamily: 'Helvetica'),
                    ),
                  )),
              // Show the tags of the event
              const Text('Tags',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Wrap(
                children: buildTags(context),
              ),

              // some space
              const SizedBox(height: 50),

              /******* Buttons from here on *******/

              // Like button
              if (isLoggedIn())
                WideButton(
                    content: ValueListenableBuilder(
                        valueListenable: favorited,
                        builder: (context, value, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                value ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                              ),
                              const SizedBox(width: 5.0),
                              Text(value
                                  ? 'Unfavorite Event'
                                  : 'Favorite Event'),
                            ],
                          );
                        }),
                    backgroundColor: const Color.fromRGBO(236, 64, 122, 1),
                    foregroundColor: Colors.white,
                    onPressedFunc: () async {
                      await toggleLikeEvent(event
                          .id); // Call toggleLikeEvent to like/unlike the event
                      event.isFavorited = !event
                          .isFavorited; // Update the local Event object's favorited status
                      favorited.value = !favorited
                          .value; // Update the ValueNotifier to update the heart icon
                      // Show a toast message to confirm the like/unlike action
                      Fluttertoast.showToast(
                          msg: event.isFavorited
                              ? 'Favorited successfully'
                              : 'Unfavorited successfully',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[800],
                          textColor: Colors.white,
                          fontSize: 16.0);

                      // notify the parent page to refresh
                      widget.refreshParent();
                    }),

              const SizedBox(height: 10),

              // Save to calendar button
              WideButton(
                  content: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                      ),
                      SizedBox(width: 5.0),
                      Text('Save to Calendar'),
                    ],
                  ),
                  onPressedFunc: () async {
                    // Call saveEventToCalendar to save the event to the user's calendar
                    await saveEventToCalendar(context, event);
                  }),

              const SizedBox(height: 10),

              // Contact button
              WideButton(
                  content: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 5.0),
                      Text('Contact Host'),
                    ],
                  ),
                  onPressedFunc: () async {
                    if (event.contactEmail != null) {
                      // Call contactHost to send an email to the host
                      await MailUtils.contactHost(
                          event.contactEmail, event.title);
                    } else {
                      // Show a toast message if the host email is not provided
                      Fluttertoast.showToast(
                          msg: 'Host email not provided',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[800],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),

              const SizedBox(height: 10),

              // Share button
              WideButton(
                  content: const Row(
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
                  onPressedFunc: () {
                    // Call share to share the event details as  text
                    Share.share(
                        'Check out this event: ${event.title} at ${event.location} on ${timeFormat(event.start)}');
                  }),

              /******* Buttons only visible to users who's authorized to edit/delete the event *******/

              // Space between the buttons (only if the event is from the college calendar (for claiming the event) or created by the current user (for editing the event))
              if (isLoggedIn() && (event.hostName == "Grinnell Calendar" || isCreatedByThisUser))
                const SizedBox(height: 30),

              // Claim Event button
              if (isLoggedIn() && !isCreatedByThisUser && event.hostName == "Grinnell Calendar") // only show if the event is from the college calendar
                WideButton(
                  content: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.how_to_reg_outlined, size: 20),
                      SizedBox(width: 5.0),
                      Text('Claim Event'),
                  ],), onPressedFunc: confirmClaim),

              // Edit button
              if (isCreatedByThisUser)
                WideButton(
                    content: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                        SizedBox(width: 5.0),
                        Text('Edit Event'),
                      ],
                    ),
                    onPressedFunc: () async {
                      // Navigate to the event edit page to edit the event
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EventEditPage(
                                  event: event, refreshParent: refresh)));
                    }),

              if (isCreatedByThisUser) const SizedBox(height: 10),

              // Delete button
              if (isCreatedByThisUser)
                WideButton(
                    content: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          size: 20,
                        ),
                        SizedBox(width: 5.0),
                        Text('Delete'),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    onPressedFunc:
                        confirmDeletion //pop up a dialog to confirm deletion and delete the event
                    ),
              const SizedBox(height: 10),
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
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Helvetica',
                    color: Colors.red[800])),
          ),
        ));
      }
    }

    return allCards;
  }
}

/// A helper class of a wide rounded elevated button button
class WideButton extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;
  final Color foregroundColor;
  final Function onPressedFunc;

  const WideButton({
    super.key,
    required this.content,
    this.backgroundColor = const Color.fromARGB(255, 255, 172, 28),
    this.foregroundColor = Colors.black,
    required this.onPressedFunc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor),
          child: content,
          onPressed: () {
            onPressedFunc();
          }),
    );
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
