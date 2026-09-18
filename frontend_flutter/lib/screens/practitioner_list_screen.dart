import 'package:flutter/material.dart';
import '../app_state.dart';
import 'practitioner_profile_screen.dart';

class PractitionerListScreen extends StatelessWidget {
  const PractitionerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final practitioners = AppState.instance.availablePractitioners;

        if (practitioners.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Practitioners')),
            body: const Center(child: Text('Register or sign in to see practitioners.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Practitioners')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: practitioners.length,
              itemBuilder: (context, index) {
                final practitioner = practitioners[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFF0F766E), child: Icon(Icons.medical_services, color: Colors.white)),
                    title: Text(practitioner.name),
                    subtitle: Text('${practitioner.role} • ${practitioner.email}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PractitionerProfileScreen(practitionerName: practitioner.name)));
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
