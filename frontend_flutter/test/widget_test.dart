// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:healthage_app/main.dart';
import 'package:healthage_app/screens/admin_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App starts and shows the new validation marketing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthAge());

    expect(find.text('Validation & Social Proof'), findsOneWidget);
  });

  testWidgets('Tapping Patient role opens AuthScreen with role hint', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const HealthAge());

    final patientFinder = find.text('Continue as Patient / Family');
    expect(patientFinder, findsOneWidget);
    await tester.ensureVisible(patientFinder);
    await tester.pumpAndSettle();
    await tester.tap(patientFinder);
    await tester.pumpAndSettle();

    expect(find.textContaining('required role'), findsOneWidget);
    expect(find.text('HealthAge MVP'), findsWidgets);
  });

  testWidgets('Admin dashboard displays defense metrics', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminScreen()));

    expect(find.text('Defense metrics'), findsOneWidget);
    expect(find.text('153'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('16'), findsNWidgets(2));
  });
}
