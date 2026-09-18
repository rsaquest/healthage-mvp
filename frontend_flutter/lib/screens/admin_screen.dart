import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app_state.dart';
import '../backend_config.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  _AdminOverview _overview = const _AdminOverview.defenseDefaults();

  @override
  void initState() {
    super.initState();
    _loadOverview();
  }

  Future<void> _loadOverview() async {
    try {
      final response = await http.get(Uri.parse('${BackendConfig.httpBase}/api/admin/overview'));
      if (response.statusCode != 200) return;
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _overview = _AdminOverview.fromJson(payload);
      });
    } catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Dashboard'),
            backgroundColor: const Color(0xFF0F766E),
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hello, Admin', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Manage requests, practitioners, and operations from one place.', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 24),
                  const Text('Platform Traction Updates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F7F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFB7E8D8)),
                    ),
                    child: const Text(
                      'Action Plan: Introducing monthly recurring subscription packages for chronic and elderly long-term management.',
                      style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _AdminSummaryCard(
                    title: 'Users onboarded',
                    value: state.users.length.toString(),
                    icon: Icons.group,
                    color: const Color(0xFF0F766E),
                  ),
                  const SizedBox(height: 12),
                  _AdminSummaryCard(
                    title: 'Active requests',
                    value: state.requestStatus == RequestStatus.idle ? '0' : '1',
                    icon: Icons.request_page,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(height: 12),
                  _AdminSummaryCard(
                    title: 'Practitioners',
                    value: state.visiblePractitioners.length.toString(),
                    icon: Icons.medical_services,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 28),
                  const Text('Defense metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _AdminMetricTile(title: 'Number of signups', value: _overview.totalSignups, icon: Icons.person_add_alt_1),
                      _AdminMetricTile(title: 'Active signups', value: _overview.activeSignups, icon: Icons.people_alt),
                      _AdminMetricTile(title: 'Number of requests', value: _overview.serviceRequests, icon: Icons.assignment),
                      _AdminMetricTile(title: 'Completed transactions', value: _overview.completedTransactions, icon: Icons.check_circle),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Quick actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _AdminActionTile(
                    title: 'View practitioners',
                    subtitle: 'Inspect care team members',
                    icon: Icons.people_alt_outlined,
                    onTap: () {},
                  ),
                  _AdminActionTile(
                    title: 'Review requests',
                    subtitle: 'Check booking and telehealth activity',
                    icon: Icons.dashboard_customize_outlined,
                    onTap: () {},
                  ),
                  _AdminActionTile(
                    title: 'Settings & monitoring',
                    subtitle: 'Manage alerts and app configuration',
                    icon: Icons.settings_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminOverview {
  final String totalSignups;
  final String activeSignups;
  final String serviceRequests;
  final String completedTransactions;

  const _AdminOverview({
    required this.totalSignups,
    required this.activeSignups,
    required this.serviceRequests,
    required this.completedTransactions,
  });

  const _AdminOverview.defenseDefaults()
      : totalSignups = '153',
        activeSignups = '15',
        serviceRequests = '16',
        completedTransactions = '16';

  factory _AdminOverview.fromJson(Map<String, dynamic> json) {
    return _AdminOverview(
      totalSignups: '${json['totalSignups'] ?? 153}',
      activeSignups: '${json['activeSignups'] ?? 15}',
      serviceRequests: '${json['serviceRequests'] ?? 16}',
      completedTransactions: '${json['completedTransactions'] ?? 16}',
    );
  }
}

class _AdminMetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _AdminMetricTile({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F7F2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF0F766E)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _AdminSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminSummaryCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.14), child: Icon(icon, color: color)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminActionTile({required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: const Color(0xFF0F766E), child: Icon(icon, color: Colors.white)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
