import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:healthage_app/main.dart';
import 'package:healthage_app/app_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('patient login, order medication, and confirm delivery', (WidgetTester tester) async {
    // Reset app state for reproducible results.
    final state = AppState.instance;
    state.logout();
    state.clearError();

    await tester.pumpWidget(const HealthAge());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to HealthAge MVP'), findsOneWidget);

    await tester.tap(find.text('Continue as Patient / Family'));
    await tester.pumpAndSettle();

    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).at(1);
    await tester.enterText(emailField, 'daniel@healthage.com');
    await tester.enterText(passwordField, 'demo123');
    await tester.pumpAndSettle();

    final loginButton = find.widgetWithText(ElevatedButton, 'Log In');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('HealthAge MVP'), findsWidgets);
    final medicationLabel = find.text('Medication');
    await tester.ensureVisible(medicationLabel);
    expect(medicationLabel, findsOneWidget);

    await tester.tap(medicationLabel);
    await tester.pumpAndSettle();

    expect(find.text('Medication Shop'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Paracetamol');
    await tester.pumpAndSettle();

    expect(find.text('Paracetamol 500mg'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Order'));
    await tester.pumpAndSettle();

    final cardPaymentTile = find.widgetWithText(ListTile, 'Card payment');
    await tester.ensureVisible(cardPaymentTile);
    await tester.tap(cardPaymentTile);
    await tester.pumpAndSettle();

    expect(find.text('Medication orders'), findsOneWidget);
    expect(find.text('Paracetamol 500mg'), findsNWidgets(2));
    expect(find.textContaining('Card payment'), findsOneWidget);

    // Confirm delivery on the medication order summary.
    final orderedItem = find.text('Paracetamol 500mg').at(1);
    final orderCard = find.ancestor(of: orderedItem, matching: find.byType(Card)).first;
    final deliveryButton = find.descendant(of: orderCard, matching: find.widgetWithText(ElevatedButton, 'Confirm delivery')).first;

    await tester.ensureVisible(deliveryButton);
    await tester.pumpAndSettle();
    await tester.tap(deliveryButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Delivered'), findsOneWidget);
  });
}
