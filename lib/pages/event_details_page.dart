import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/pages/edit_event_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    bool isCreatedByThisUser = event.host == USER.value?.id;
    var favorited = ValueNotifier(event.isFavoited);

    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text('Event Details',
              style: TextStyle(fontWeight: FontWeight.w800)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            if (isLoggedIn())
              ValueListenableBuilder(
                  valueListenable: favorited,
                  builder: (context, value, child) {
                    return IconButton(
                        icon: value
                            ? Icon(Icons.favorite, color: Colors.white)
                            : Icon(Icons.favorite_border, color: Colors.white),
                        tooltip: value ? 'Unsave the event' : 'Save the event',
                        onPressed: () {
                          toggleLikeEvent(event.id);
                          event.isFavoited = !value;
                          favorited.value = !value;
                          Fluttertoast.showToast(
                              msg: value
                                  ? 'Unsaved successfully'
                                  : 'Saved successfully',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[800],
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                  })
          ]),
      body: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                            fontWeight: FontWeight.bold))),
              ]),
              Text('Host',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(
                event.hostName
                    .toString(), //TODO: currently it shows host's user id, we need a way to access host's name
                style: TextStyle(fontSize: 20),
              ),
              Text('Location',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(event.location ?? 'Null location',
                  style: TextStyle(fontSize: 20)),
              Text('Starts at',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(timeFormat(event.start) ?? 'Null start date',
                  style: TextStyle(fontSize: 20)),
              Text('Ends at',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(timeFormat(event.end) ?? 'Null end date',
                  style: TextStyle(fontSize: 20)),
              Text('Description:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(event.description ?? 'Null description',
                      style: TextStyle(fontSize: 16)),
                ),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              Text('Tags:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              //TODO: show tags here

              // some space
              const SizedBox(height: 50),

              //TODO: Nam - Add other buttons here, put them in sizedbox if you want them to be full width

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

              const SizedBox(height: 15),

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
                      onPressed: () {}),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
