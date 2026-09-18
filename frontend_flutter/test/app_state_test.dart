import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthage_app/app_state.dart';

void main() {
  final state = AppState.instance;

  setUp(() {
    state.logout();
    state.clearError();
  });

  test('registerUser creates account and authenticates', () {
    final email = 'unique_user@example.com';
    final created = state.registerUser(name: 'Unique', email: email, password: 'pw123', role: 'Patient');
    expect(created, isTrue);
    expect(state.isAuthenticated, isTrue);
    expect(state.currentUser?.email, equals(email));
  });

  test('registerUser rejects duplicate email', () {
    final email = 'daniel@healthage.com';
    final created = state.registerUser(name: 'Dup', email: email, password: 'pw', role: 'Patient');
    expect(created, isFalse);
    expect(state.lastError, isNotNull);
  });

  test('loginUser succeeds and fails appropriately', () {
    final ok = state.loginUser(email: 'ada@healthage.com', password: 'demo123');
    expect(ok, isTrue);
    expect(state.isAuthenticated, isTrue);
    state.logout();
    final bad = state.loginUser(email: 'ada@healthage.com', password: 'wrong');
    expect(bad, isFalse);
    expect(state.isAuthenticated, isFalse);
  });

  test('booking lifecycle requires auth and updates status', () {
    state.logout();
    final resultUnauth = state.submitBooking(
      patientName: 'P',
      serviceType: 'Nursing',
      practitionerName: 'Dr',
      location: 'Home',
      preferredDate: DateTime.now(),
      preferredTime: TimeOfDay(hour: 9, minute: 0),
    );
    expect(resultUnauth, isFalse);
    expect(state.lastError, isNotNull);

    state.loginUser(email: 'daniel@healthage.com', password: 'demo123');
    final result = state.submitBooking(
      patientName: 'P',
      serviceType: 'Nursing',
      practitionerName: 'Dr',
      location: 'Home',
      preferredDate: DateTime.now(),
      preferredTime: TimeOfDay(hour: 9, minute: 0),
    );
    expect(result, isTrue);
    expect(state.requestStatus, equals(RequestStatus.requested));
    expect(state.latestBooking, isNotNull);

    state.requestVideoCheckin();
    expect(state.latestBooking?.videoCheckinRequested, isTrue);

    state.caregiverAcceptService();
    expect(state.latestBooking?.caregiverAccepted, isTrue);

    state.caregiverUploadEvidence('https://example.com/photo.png');
    expect(state.latestBooking?.completionPhotoUrl, contains('photo.png'));

    state.confirmPayment('Card');
    expect(state.latestBooking?.paymentConfirmed, isTrue);

    state.markArrival();
    expect(state.requestStatus, anyOf([RequestStatus.arrived, RequestStatus.requested]));

    state.markCompletion();
    expect(state.requestStatus, equals(RequestStatus.completed));

    state.submitRating(5);
    expect(state.caregiverRating, equals(5));
  });

  test('medication order flow', () {
    final before = state.medicationOrders.length;
    state.submitMedicationOrder(name: 'Aspirin', price: '5.00', logisticsFee: '1.00', paymentMethod: 'Card');
    expect(state.medicationOrders.length, equals(before + 1));

    state.confirmMedicationDelivery('Aspirin');
    final delivered = state.medicationOrders.firstWhere((o) => o.name == 'Aspirin');
    expect(delivered.deliveryConfirmed, isTrue);

    state.reviewMedicationOrder('Aspirin', 4);
    final reviewed = state.medicationOrders.firstWhere((o) => o.name == 'Aspirin');
    expect(reviewed.reviewRating, equals(4));
  });

  test('sendMessage requires currentUser', () {
    state.logout();
    final before = state.chatMessages.length;
    state.sendMessage('Hello');
    expect(state.chatMessages.length, equals(before));
    state.loginUser(email: 'daniel@healthage.com', password: 'demo123');
    state.sendMessage('Hello again');
    expect(state.chatMessages.length, greaterThanOrEqualTo(before + 1));
  });

  test('registering a practitioner makes them appear in the practitioner list', () {
    final email = 'practitioner_xyz@example.com';
    final created = state.registerUser(name: 'Dr. Test', email: email, password: 'pw', role: 'Practitioner');
    expect(created, isTrue);
    expect(state.visiblePractitioners.map((u) => u.email), contains(email));
  });

  test('login fails when the account has not been registered', () {
    final ok = state.loginUser(email: 'missing@example.com', password: 'secret123');
    expect(ok, isFalse);
  });
}
