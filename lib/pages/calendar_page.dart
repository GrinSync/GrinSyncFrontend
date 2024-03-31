import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_test_app/api/new_event_info.dart';
import 'package:flutter_test_app/main.dart';

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
        timeIntervalHeight: -1,
        timeIntervalWidth: -1,
        minimumAppointmentDuration: Duration(minutes: 15),
        dateFormat: 'd',
        dayFormat: 'EEE',
      ),
      blackoutDates: <DateTime>[],
      dataSource: EventDataSource(getAllEvents()),
    ));
  }
} // CalendarPageState

List<Appointment> getAllEvents() {
  List<Appointment> allEvents = <Appointment>[];
  return allEvents;
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> events) {
    appointments = events;
  }
}
