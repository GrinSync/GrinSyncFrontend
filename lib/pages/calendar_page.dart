// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

  @override
  Widget build(BuildContext context) {
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
      // dataSource: EventDataSource(getAllAppointmentData()),
      dataSource: getSampleDataSource(),
      appointmentTextStyle: TextStyle(),
    ));
  }
} // CalendarPageState

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

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

List<int> parseFormattedTime(String time) {
  int month = int.parse(time.substring(0, 2));
  int day = int.parse(time.substring(3, 5));
  int year = int.parse(time.substring(6, 10));
  int hour = int.parse(time.substring(11, 13));
  int minute = int.parse(time.substring(14, 16));

  List<int> res = <int>[month, day, year, hour, minute];
  return res;
}

Future<List<Appointment>> getAllAppointmentData() async {
  List<Appointment> allAppointments = <Appointment>[];

  late List<Event> allEvents;
  late Future<void> _loadEventsFuture;

  Future<void> loadEvents() async {
    allEvents = await getUpcomingEvents();
  }

  _loadEventsFuture = loadEvents();

  for (int index = 0; index < allEvents.length; index++) {
    String title = allEvents[index].title ?? "";
    String description = allEvents[index].description ?? "";
    String startTime = allEvents[index].start ?? "";
    String endTime = allEvents[index].end ?? "";
    // String location = allEvents[index].location ?? "";
    // bool studentsOnly = allEvents[index].studentsOnly ?? true;
    // List<EventTags> tags = allEvents[index].tags;

    // if (studentsOnly)

    List<int> startTimeParsed = parseFormattedTime(startTime);
    List<int> endTimeParsed = parseFormattedTime(endTime);

    Appointment apt = Appointment(
      startTime: DateTime(
        startTimeParsed[2],
        startTimeParsed[0],
        startTimeParsed[1],
        startTimeParsed[3],
        startTimeParsed[4],
      ),
      endTime: DateTime(
        endTimeParsed[2],
        endTimeParsed[0],
        endTimeParsed[1],
        endTimeParsed[3],
        endTimeParsed[4],
      ),
      // location: location,
      subject: title,
      notes: description,
    );

    allAppointments.add(apt);
  }

  return allAppointments;
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(Future<List<Appointment>> events) {
    // appointments = events;
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
