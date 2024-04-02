import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.day,
      firstDayOfWeek: 7,
      minDate: DateTime(2024, 08, 14, 0, 0, 0),
      maxDate: DateTime(2025, 05, 25, 0, 0, 0),
      allowedViews: [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
        CalendarView.schedule
      ],
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        dayFormat: 'EEE',
      ),
      scheduleViewSettings: ScheduleViewSettings(
        hideEmptyScheduleWeek: true,
      ),
      timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: Duration(minutes: 30),
        timeFormat: "hh:mm",
        timeIntervalHeight: 100,
        timeIntervalWidth: 25,
        minimumAppointmentDuration: Duration(minutes: 15),
        dateFormat: 'd',
        dayFormat: 'EEE',
      ),
      blackoutDates: <DateTime>[],
      dataSource: EventDataSource(getAllEvents()),
    ));
  }
} // CalendarPageState

List<int> parseFormattedTime(String time) {
  int month = int.parse(time.substring(0, 2));
  int day = int.parse(time.substring(3, 5));
  int year = int.parse(time.substring(6, 10));
  int hour = int.parse(time.substring(11, 13));
  int minute = int.parse(time.substring(14, 16));

  List<int> res = <int>[month, day, year, hour, minute];
  return res;
}

Future<List<Appointment>> getAllEvents() async {
  List<Appointment> allEvents = <Appointment>[];

  var url = Uri.parse('http://grinsync.com/api/create/event');
  final response = await http.get(url);
  var responseData = json.decode(response.body);

  for (var obj in responseData) {
    String title = obj["title"];
    String description = obj["description"];
    String time = obj["date"];
    String location = obj["location"];
    bool studentsOnly = obj["students_only"];
    // List<EventTags> tags = obj["tags"];

    // if (studentsOnly)

    List<String> temp = time.split("-");
    String startTime = temp[0];
    String endTime = temp[1];

    List<int> startTimeParsed = parseFormattedTime(startTime);
    List<int> endTimeParsed = parseFormattedTime(endTime);

    Appointment event = Appointment(
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
      location: location,
      subject: title,
      notes: description,
    );

    allEvents.add(event);
  }

  return allEvents;
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
