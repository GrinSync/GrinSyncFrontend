// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

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
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      calendarController.selectedDate = null;
    });
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {}
  }

  late List<Event> allEvents = <Event>[];
  late Future<void> loadEventsFuture;

  Future<void> loadEvents() async {
    allEvents = await getAllEvents();
  }

  @override
  void initState() {
    super.initState();
    loadEventsFuture = loadEvents();
  }

  // ignore: library_private_types_in_public_api
  _AppointmentDataSource getSampleDataSource() {
    List<Appointment> appointments = <Appointment>[];

    appointments.add(Appointment(
      startTime: DateTime(2024, 4, 3, 10, 00),
      endTime: DateTime(2024, 4, 3, 11, 50),
      subject: 'Class',
      color: Color.fromARGB(255, 218, 41, 28),
    ));

    return _AppointmentDataSource(appointments);
  }

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
          // if the connection is waiting, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                const Text('Preparing the calendar for you...'),
              ],
            );
            // if there is an error, show an error message and a button to try again
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
            // if the connection is done, show the events
          } else {
            // if there are no events, show a message
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
              // if there are events, show the events
            } else {
              return Scaffold(
                  body: SfCalendar(
                controller: calendarController,
                onViewChanged: calendarViewChanged,
                onTap: calendarTapped,
                view: CalendarView.day,
                firstDayOfWeek: 7,
                minDate: DateTime(2023, 08, 14, 0, 0, 0),
                maxDate: DateTime(2025, 05, 25, 0, 0, 0),
                allowedViews: [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                  CalendarView.schedule
                ],
                allowViewNavigation: true,
                viewNavigationMode: ViewNavigationMode.none,
                monthViewSettings: const MonthViewSettings(
                  dayFormat: 'EEE',
                  monthCellStyle: MonthCellStyle(),
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  showAgenda: true,
                  agendaViewHeight: 200,
                  agendaStyle: AgendaStyle(),
                  navigationDirection: MonthNavigationDirection.horizontal,
                ),
                scheduleViewSettings: const ScheduleViewSettings(
                  hideEmptyScheduleWeek: true,
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
                blackoutDates: <DateTime>[],
                dataSource: EventDataSource(getAllAppointmentData()),
                // dataSource: getSampleDataSource(),
                appointmentTextStyle: TextStyle(),
              ));
            }
          }
        });
  }
} // CalendarPageState