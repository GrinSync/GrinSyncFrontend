// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/pages/event_details_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

/// Extending the CalendarDataSource abstract class to take in a list of events
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

  void calendarViewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      calendarController.selectedDate = null;
    });
  }

  /// Detects whether an event card is being tapped on
  /// and routes the user to the Event Details page
  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => EventDetailsPage(event: ),
      //   ),
      // );
    }
  }

  /// Initializes empty list of event
  late List<Event> allEvents = <Event>[];

  /// Declares a future function call to load all events with the API call
  late Future<void> loadEventsFuture;

  Future<void> loadEvents() async {
    allEvents = await getAllEvents();
  }

  @override
  void initState() {
    super.initState();
    loadEventsFuture = loadEvents();
  }

  /// Gets the data for all the events by mapping fields from the Json responses
  /// to the fields that can be converted to calendar-readable format
  List<Appointment> getAllAppointmentData() {
    List<Appointment> allAppointments = <Appointment>[];

    for (int index = 0; index < allEvents.length; index++) {
      String title = allEvents[index].title ?? "";
      String description = allEvents[index].description ?? "";
      String startTime = allEvents[index].start ?? "";
      String endTime = allEvents[index].end ?? "";
      // String location = allEvents[index].location ?? "";
      // bool studentsOnly = allEvents[index].studentsOnly ?? true;
      // List<EventTags> tags = allEvents[index].tags;

      // if (studentsOnly)

      Appointment apt = Appointment(
        startTime: DateTime.parse(startTime),
        endTime: DateTime.parse(endTime),
        // location: location,
        subject: title,
        notes: description,
        startTimeZone:
            'UTC', // Need these so that it interprets the given datetimes as offsets from UTC, which they are
        endTimeZone:
            'UTC', // The calendar widget will automatically update the time in the user's timezone
        color: Color.fromARGB(255, 156, 25, 15),
      );

      allAppointments.add(apt);
    }

    return allAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadEventsFuture,
        builder: (context, snapshot) {
          // If the connection is waiting, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Preparing the calendar for you...'),
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
                      loadEvents();
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
                body: Container(
                  padding: EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: loadEvents,
                    child: Center(
                      child: ListView(
                        children: [const Text('No events to show here')],
                      ),
                    ),
                  ),
                ),
              );

              // If there are events, show the events
            } else {
              return Scaffold(
                  // Return the actual calendar
                  body: SfCalendar(
                controller: calendarController,
                onViewChanged: calendarViewChanged,
                onTap: calendarTapped,
                view: CalendarView.day, // default view of the calendar
                firstDayOfWeek:
                    7, // default first day of the week set to Sunday
                minDate: DateTime(2023, 08, 14, 0, 0, 0),
                maxDate: DateTime(2025, 05, 25, 0, 0, 0),
                allowedViews: [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                ], // the calendar only allows three views - discussed in previous milestones
                allowViewNavigation: true,
                viewNavigationMode: ViewNavigationMode.none,
                monthViewSettings: const MonthViewSettings(
                  dayFormat: 'EEE',
                  monthCellStyle: MonthCellStyle(),
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  appointmentDisplayCount: 4,
                  showAgenda: true,
                  agendaViewHeight: 200,
                  agendaStyle: AgendaStyle(),
                  navigationDirection: MonthNavigationDirection.horizontal,
                ),
                timeSlotViewSettings: const TimeSlotViewSettings(
                  timeInterval: Duration(minutes: 30),
                  timeFormat: "hh:mm",
                  timeIntervalHeight: 50,
                  timeIntervalWidth: 25,
                  minimumAppointmentDuration: Duration(minutes: 15),
                  dateFormat: 'd',
                  dayFormat: 'EEE',
                  // allDayPanelColor: Color.fromARGB(255, 162, 54, 70)
                ),
                showDatePickerButton: true,
                showTodayButton: true,
                blackoutDates: <DateTime>[], // list of blackout dates when no events are allowed to happen
                dataSource: EventDataSource(
                    getAllAppointmentData()), // get the event data
                appointmentTextStyle: TextStyle(
                  color: Color(0xFFFFFFFF),
                ),
              ));
            }
          }
        });
  }
} // CalendarPageState
