import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_state.dart';
import '../backend_config.dart';

class RecipientInvitesScreen extends StatefulWidget {
  const RecipientInvitesScreen({super.key});

  @override
  State<RecipientInvitesScreen> createState() => _RecipientInvitesScreenState();
}

class _RecipientInvitesScreenState extends State<RecipientInvitesScreen> {
  final TextEditingController _codeController = TextEditingController();
  final _backend = BackendConfig.httpBase;
  List<dynamic> _invites = [];
  bool _loading = false;

  Future<void> _fetchInvites() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    setState(() => _loading = true);
    try {
      final resp = await http.get(Uri.parse('$_backend/api/invites?userCode=$code'));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          _invites = data['invites'] as List<dynamic>;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch invites: ${resp.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _accept(int id) async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    final userId = AppState.instance.currentUserId ?? 0;
    try {
      final resp = await http.post(Uri.parse('$_backend/api/emergency-contacts/$id/accept'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'userId': userId}));
      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite accepted')));
        await _fetchInvites();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to accept: ${resp.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Invites'), backgroundColor: const Color(0xFF0F766E)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Enter your HealthAge code'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _fetchInvites, child: const Text('Check invites')),
            const SizedBox(height: 12),
            if (_loading) const CircularProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: _invites.length,
                itemBuilder: (context, index) {
                  final inv = _invites[index];
                  return Card(
                    child: ListTile(
                      title: Text(inv['name'] ?? 'Invite from patient ${inv['patientId']}'),
                      subtitle: Text('Code: ${inv['userCode'] ?? ''}'),
                      trailing: ElevatedButton(onPressed: () => _accept(inv['id']), child: const Text('Accept')),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
