// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grinsync/api/get_events.dart';
import 'package:grinsync/models/event_models.dart';
import 'package:grinsync/pages/event_details_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:grinsync/api/user_authorization.dart';
import 'package:grinsync/api/tags.dart';

/// Enum for the filter options for the calendar page
enum filterOptions {
  myPreferences("By user preferences"),
  myEvents("By events you created"),
  likedEvents("By events you like");

  // Have a label for each of the filter
  const filterOptions(this.label);
  final String label;
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

/// Extends the CalendarDataSource abstract class to take in a list of events
/// and map the fields of each event to the fields of an object that can be read and displayed by calendars
class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> events) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  final CalendarController calendarController = CalendarController();

  /// List of all events that will be displayed on the calendar page
  late List<Event> allEvents = <Event>[];

  /// The label of the current filtering option
  filterOptions currentFilter =
      filterOptions.myPreferences; // defaulted to user's own agenda

  /// List of user's preferred tags if logged in
  List<String> selectedTags = isLoggedIn() ? getPreferredTags() : getAllTags();

  /// Future function call to load all events with the API call
  late Future<void> loadEventsFuture;

  /// Loads all events based on the given filter option
  Future<void> loadEvents(filterOptions option) async {
    // Do not load events if the user is not logged in
    if (!isLoggedIn()) return;

    // Reload calendar events depending on the filter option
    switch (option) {
      case filterOptions.myPreferences:
        allEvents = await getAllEventsByPreferences(selectedTags, false, false);
      case filterOptions.myEvents:
        allEvents = await getMyEvents();
      case filterOptions.likedEvents:
        allEvents = await getLikedEvents();
    }
  }

  @override
  void initState() {
    super.initState();
    // defaulted to user's own agenda
    loadEventsFuture = loadEvents(filterOptions.myPreferences);
  }

  /// Reloads the events based on the current filter everytime the users refresh
  refresh() {
    setState(() {
      loadEventsFuture = loadEvents(currentFilter);
    });
  }

  void calendarViewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      calendarController.selectedDate = null;
    });
  }

  /// Detects whether an event card is being tapped on
  /// and routes the user to the Event Details page
  void calendarTapped(CalendarTapDetails details) {
    // If the element being tapped on is an appointment, or an event card in other words
    if (details.targetElement == CalendarElement.appointment) {
      // Get the first and only appointment object that is being tapped on
      Appointment event = details.appointments!.first;
      // Get the id of the appointment (same id as in the list of events)
      Object? id = event.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailsPage(
              // Look for the single event in the list that has a matching ID
              event: allEvents.singleWhere((element) => element.id == id),
              refreshParent: refresh),
        ),
      );
    }
  }

  /// Gets the data for all the events by mapping fields from the Json responses
  /// to the fields that can be converted to calendar-readable format
  List<Appointment> getAllAppointmentData() {
    List<Appointment> allAppointments = <Appointment>[];

    for (int index = 0; index < allEvents.length; index++) {
      // Extracts information from each event
      int eventID = allEvents[index].id;
      String title = allEvents[index].title;
      String description = allEvents[index].description;
      String startTime = allEvents[index].start ?? "";
      String endTime = allEvents[index].end ?? "";
      String location = allEvents[index].location;

      // Maps each extracted information to a field in the calendar appointment object
      Appointment apt = Appointment(
        id: eventID,
        // Parses a string time and convert into a DateTime object
        startTime: DateTime.parse(startTime),
        endTime: DateTime.parse(endTime),
        location: location,
        subject: title,
        notes: description,
        startTimeZone:
            'UTC', // Need these so that it interprets the given datetimes as offsets from UTC, which they are
        endTimeZone:
            'UTC', // The calendar widget will automatically update the time in the user's timezone
        color: const Color.fromARGB(255, 156, 25, 15),
      );

      allAppointments.add(apt);
    }

    return allAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Shows an app bar above the calendar page separate from the future builder
        appBar: AppBar(
          title: const Text(
            'Calendar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions:
              !isLoggedIn() // Shows the menu button only if the users are logged in
                  ? []
                  : [
                      // The label of the current filter
                      Text(currentFilter.label),
                      // A pop up menu button
                      PopupMenuButton(
                        icon: const Icon(Icons.filter_alt),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: filterOptions.myPreferences,
                            child: Text(filterOptions.myPreferences.label),
                          ),
                          PopupMenuItem(
                            value: filterOptions.myEvents,
                            child: Text(filterOptions.myEvents.label),
                          ),
                          PopupMenuItem(
                            value: filterOptions.likedEvents,
                            child: Text(filterOptions.likedEvents.label),
                          ),
                        ],
                        // Sets the state and reload the page (a stateful builder)
                        // depending on the selected filter option
                        onSelected: (filterOptions option) {
                          setState(() {
                            loadEventsFuture = loadEvents(option);
                            currentFilter = option;
                          });
                        },
                      ),
                    ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: !isLoggedIn()
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Welcome to GrinSync!',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Text('Please log in or register to view the calendar.'),
                  ],
                ),
              )
            : FutureBuilder(
                future: loadEventsFuture,
                builder: (context, snapshot) {
                  // If the connection is waiting, show a loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Center(
                            child: Text('Preparing the calendar for you...')),
                      ],
                    );

                    // If there is an error, show an error message and a button to try again
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Error loading events'),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              loadEvents(filterOptions.likedEvents);
                            });
                          },
                          child: const Text('Try again'),
                        ),
                      ],
                    );

                    // If the connection is done, show the events
                  } else {
                    // If there are no events, show a message
                    if (allEvents.isEmpty) {
                      return Scaffold(
                        body: SfCalendar(
                          controller: calendarController,
                          onViewChanged: calendarViewChanged,
                          onTap: calendarTapped,
                          view:
                              CalendarView.day, // default view of the calendar
                          firstDayOfWeek:
                              7, // first day of the week defaulted to Sunday
                          minDate: DateTime(2023, 08, 14, 0, 0, 0),
                          maxDate: DateTime(2025, 05, 25, 0, 0, 0),
                          allowedViews: [
                            CalendarView.day,
                            CalendarView.week,
                            CalendarView.month,
                          ], // the calendar only allows three views - discussed in previous milestones
                          allowViewNavigation: true,
                          showNavigationArrow: true,
                          viewNavigationMode: ViewNavigationMode.none,
                          monthViewSettings: const MonthViewSettings(
                            dayFormat: 'EEE',
                            monthCellStyle: MonthCellStyle(),
                            navigationDirection:
                                MonthNavigationDirection.horizontal,
                          ),
                          timeSlotViewSettings: const TimeSlotViewSettings(
                            timeInterval: Duration(minutes: 30),
                            timeFormat: "hh:mm",
                            timeIntervalHeight: 50,
                            timeIntervalWidth: 25,
                            minimumAppointmentDuration: Duration(minutes: 15),
                            dateFormat: 'd',
                            dayFormat: 'EEE',
                          ),
                          showDatePickerButton: true,
                          showTodayButton: true, // get the event data
                        ),
                      );

                      // If there are events, show the events
                    } else {
                      return Scaffold(
                        // Returns the actual calendar
                        body: SfCalendar(
                          controller: calendarController,
                          onViewChanged: calendarViewChanged,
                          onTap: calendarTapped,
                          view:
                              CalendarView.day, // default view of the calendar
                          firstDayOfWeek:
                              7, // first day of the week defaulted to Sunday
                          minDate: DateTime(2023, 08, 14, 0, 0, 0),
                          maxDate: DateTime(2025, 05, 25, 0, 0, 0),
                          allowedViews: [
                            CalendarView.day,
                            CalendarView.week,
                            CalendarView.month,
                          ], // the calendar only allows three views - discussed in previous milestones
                          allowViewNavigation: true,
                          showNavigationArrow: true,
                          viewNavigationMode: ViewNavigationMode.none,
                          monthViewSettings: const MonthViewSettings(
                            dayFormat: 'EEE',
                            monthCellStyle: MonthCellStyle(),
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator,
                            appointmentDisplayCount: 4,
                            showAgenda: true,
                            agendaViewHeight: 200,
                            agendaStyle: AgendaStyle(),
                            navigationDirection:
                                MonthNavigationDirection.horizontal,
                          ),
                          timeSlotViewSettings: const TimeSlotViewSettings(
                            timeInterval: Duration(minutes: 30),
                            timeFormat: "hh:mm",
                            timeIntervalHeight: 50,
                            timeIntervalWidth: 25,
                            minimumAppointmentDuration: Duration(minutes: 15),
                            dateFormat: 'd',
                            dayFormat: 'EEE',
                          ),
                          showDatePickerButton: true,
                          showTodayButton: true,
                          blackoutDates: <DateTime>[], // list of blackout dates when no events are allowed to happen
                          dataSource: EventDataSource(
                              getAllAppointmentData()), // get the event data
                          appointmentTextStyle: const TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      );
                    }
                  }
                },
              ));
  }
} // CalendarPageState
