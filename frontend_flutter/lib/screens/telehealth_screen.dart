import 'package:flutter/material.dart';
import '../app_state.dart';
import 'auth_screen.dart';

class TelehealthScreen extends StatelessWidget {
  const TelehealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    if (!state.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Telehealth Consultation')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in to start a consultation.'),
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
      appBar: AppBar(title: const Text('Telehealth Consultation')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF0F172A),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_call, color: Colors.white, size: 56),
                      SizedBox(height: 12),
                      Text('Live consultation session', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Dr. Ada Okafor is connecting now', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.small(
                  heroTag: 'telehealth_mic',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Microphone muted/unmuted')));
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.mic, color: Colors.black),
                ),
                FloatingActionButton(
                  heroTag: 'telehealth_end_call',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.call_end),
                ),
                FloatingActionButton.small(
                  heroTag: 'telehealth_camera',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera switched')));
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.videocam, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const ListTile(
                leading: Icon(Icons.schedule, color: Color(0xFF0F766E)),
                title: Text('Upcoming session'),
                subtitle: Text('In 5 minutes with Dr. Ada Okafor'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
