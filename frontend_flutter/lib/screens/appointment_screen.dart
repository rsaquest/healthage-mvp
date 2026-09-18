import 'package:flutter/material.dart';
import '../app_state.dart';
import 'auth_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String _selectedType = 'Telehealth';
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AppState.instance.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Schedule Appointment')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in before scheduling an appointment.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen())),
                child: const Text('Go to sign in'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('Choose appointment type', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Telehealth', child: Text('Telehealth')),
                DropdownMenuItem(value: 'Home Visit', child: Text('Home Visit')),
                DropdownMenuItem(value: 'Emergency', child: Text('Emergency')),
              ],
              onChanged: (value) => setState(() => _selectedType = value ?? 'Telehealth'),
            ),
            const SizedBox(height: 12),
            TextField(controller: _notesController, maxLines: 4, decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () {
                AppState.instance.submitBooking(
                  patientName: AppState.instance.currentUser?.name ?? 'Patient',
                  serviceType: _selectedType,
                  practitionerName: AppState.instance.currentUser?.name ?? 'Assigned practitioner',
                  location: 'Home',
                  preferredDate: DateTime.now(),
                  preferredTime: TimeOfDay.now(),
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment scheduled successfully')));
                Navigator.pop(context);
              },
              child: const Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
