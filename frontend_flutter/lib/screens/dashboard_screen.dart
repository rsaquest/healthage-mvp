import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operations Dashboard'),
        backgroundColor: const Color(0xFF0F766E),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            _MetricTile(title: 'Active patients', value: '14', icon: Icons.people),
            _MetricTile(title: 'Emergency incidents', value: '2', icon: Icons.warning_amber_rounded),
            _MetricTile(title: 'Practitioners online', value: '8', icon: Icons.medical_services),
            _MetricTile(title: 'Pending verification', value: '3', icon: Icons.verified_user),
            SizedBox(height: 18),
            Text('Live operations overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 14),
            _ActivityTile(title: 'Ambulance status', subtitle: 'En route to patient'),
            _ActivityTile(title: 'Medication delivery', subtitle: 'Pharmacy confirmed dispatch'),
            _ActivityTile(title: 'Family notifications', subtitle: '3 updates sent in last hour'),
            SizedBox(height: 18),
            _ActivityTile(title: 'Dispatch readiness', subtitle: 'Ambulance and nurse teams synchronized'),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricTile({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0F766E)),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ActivityTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
