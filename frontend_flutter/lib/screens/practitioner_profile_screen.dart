import 'package:flutter/material.dart';
import 'booking_screen.dart';

class PractitionerProfileScreen extends StatelessWidget {
  final String practitionerName;

  const PractitionerProfileScreen({super.key, required this.practitionerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practitioner Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(radius: 40, backgroundColor: Color(0xFF0F766E), child: Icon(Icons.person, size: 38, color: Colors.white)),
                    const SizedBox(height: 14),
                    Text(practitionerName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('General Care • Home Visits • Telehealth', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 10),
                    Row(children: const [Icon(Icons.star, color: Colors.amber), SizedBox(width: 6), Text('4.9 rating')]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Experienced clinician focused on senior care, post-operative recovery, and home-based treatment support.'),
            const SizedBox(height: 18),
            const Text('Specializations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: const [Chip(label: Text('Elderly Care')), Chip(label: Text('Post-op Support')), Chip(label: Text('Medication Review'))]),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(practitionerName: practitionerName)));
                },
                child: const Text('Book Consultation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
