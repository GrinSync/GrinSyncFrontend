import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/main.dart';
import 'package:flutter_test_app/pages/calendar_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  Box box;
  setUp(() async {
    final temp = await Directory.systemTemp.createTemp();
    Hive.init(temp.path);
    box = await Hive.openBox('test-box');
    await box.clear();
  });
  testWidgets(
      'Test to see if the Calendar page is launched and initialized correctly',
      (WidgetTester tester) async {
    // Tell the tester to build the app.
    // await tester.pumpWidget(const MyApp());
    // Tap on the calendar icon once on the home screen
    // await tester.tap(find.byIcon(Icons.calendar_month));
    // Rebuild the widget after the state has changed.

    await tester.pumpWidget(const CalendarPage());
    // await tester.pump();

    // Check to see if there's a SfCalendar widget on the Calendar page
    expect(find.byType(SfCalendar), findsOne);

    // tester.tap(find.byIcon(Icons.more_vert));
    // expect(findsOne, find.text("Daily"));
    // expect(findsOne, find.text("Weekly"));
    // expect(findsOne, find.text("Monthly"));
    // expect(findsNothing, find.text("Schedule"));

    // tester.tap(find.byTooltip("Month"));
  });
}
