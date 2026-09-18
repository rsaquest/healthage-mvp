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
  testWidgets('App starts on the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthAge());

    expect(find.text('HealthAge MVP'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Selecting a role keeps the login form visible', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthAge());

    final adminRole = find.text('Admin');
    await tester.ensureVisible(adminRole);
    await tester.tap(adminRole);
    await tester.pump();

    expect(find.text('Admin: maya@healthage.com / demo123'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Admin dashboard displays defense metrics', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminScreen()));

    expect(find.text('Defense metrics'), findsOneWidget);
    expect(find.text('153'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('16'), findsNWidgets(2));
  });
}
