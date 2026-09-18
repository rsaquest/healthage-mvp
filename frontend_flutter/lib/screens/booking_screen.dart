import 'package:flutter/material.dart';
import '../app_state.dart';

class BookingScreen extends StatefulWidget {
  final String practitionerName;

  const BookingScreen({super.key, this.practitionerName = 'Dr. Ada Okafor'});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _patientController = TextEditingController();
  final _locationController = TextEditingController(text: 'Lagos');
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String _selectedService = 'Home Visit';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _patientController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Service')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('Request care', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Choose the support you need and our system will match a professional quickly.', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            TextField(controller: _patientController, decoration: const InputDecoration(labelText: 'Patient name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedService,
              decoration: const InputDecoration(labelText: 'Service type', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Home Visit', child: Text('Home Visit')),
                DropdownMenuItem(value: 'Telehealth', child: Text('Telehealth')),
                DropdownMenuItem(value: 'Emergency', child: Text('Emergency')),
                DropdownMenuItem(value: 'Medication review', child: Text('Medication review')),
              ],
              onChanged: (value) => setState(() => _selectedService = value ?? 'Home Visit'),
            ),
            const SizedBox(height: 12),
            TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _dateController.text = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                  });
                }
              },
              child: IgnorePointer(
                child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Preferred date', border: OutlineInputBorder()),
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
              child: IgnorePointer(
                child: TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: 'Preferred time', border: OutlineInputBorder()),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Recommended Practitioner', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${widget.practitionerName} • General Care • 4.9 rating'),
                    const SizedBox(height: 4),
                    const Text('Estimated arrival: 15 minutes'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  if (!_validateBooking()) {
                    return;
                  }

                  final success = AppState.instance.submitBooking(
                    patientName: _patientController.text.trim().isEmpty ? 'Patient' : _patientController.text.trim(),
                    serviceType: _selectedService,
                    practitionerName: widget.practitionerName,
                    location: _locationController.text.trim().isEmpty ? 'Lagos' : _locationController.text.trim(),
                    preferredDate: _selectedDate ?? DateTime.now(),
                    preferredTime: _selectedTime ?? TimeOfDay.now(),
                  );

                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppState.instance.lastError ?? 'Unable to submit request.')));
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Request submitted for ${_patientController.text.trim().isEmpty ? 'patient' : _patientController.text.trim()}')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Submit Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateBooking() {
    if (AppState.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in before requesting care.')));
      return false;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose both a date and time.')));
      return false;
    }
    return true;
  }
}
