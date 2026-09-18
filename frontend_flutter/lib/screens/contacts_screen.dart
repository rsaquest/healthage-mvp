import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_state.dart';
import '../backend_config.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _codeController = TextEditingController();
  final _backend = BackendConfig.httpBase;
  List<dynamic> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final patientId = AppState.instance.currentUserId ?? (AppState.instance.currentUser?.id ?? 0);
    try {
      final resp = await http.get(Uri.parse('$_backend/api/emergency-contacts?patientId=$patientId'));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          _contacts = data['contacts'] as List<dynamic>;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load contacts: ${resp.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to reach backend. Ensure the server is running and adb reverse tcp:3000 tcp:3000 is active.')));
    }
  }

  Future<void> _removeContact(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove contact'),
        content: const Text('Are you sure you want to remove this contact from your emergency list?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final resp = await http.delete(Uri.parse('$_backend/api/emergency-contacts/$id'));
      if (resp.statusCode == 200) {
        setState(() {
          _contacts.removeWhere((c) => c['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact removed')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove: ${resp.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error removing contact: $e')));
    }
  }

  Future<void> _resendInvite(int id) async {
    try {
      final resp = await http.post(Uri.parse('$_backend/api/emergency-contacts/$id/resend'));
      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite resent')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to resend: ${resp.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error resending invite: $e')));
    }
  }

  Future<void> _addContact() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    final patientId = AppState.instance.currentUserId ?? (AppState.instance.currentUser?.id ?? 0);
    final uri = Uri.parse('$_backend/api/emergency-contacts');
    try {
      final resp = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'patientId': patientId, 'userCode': code, 'name': code}));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite sent')));
        setState(() {
          _contacts.add(data['contact']);
          _codeController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: ${resp.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to reach backend. Ensure the server is running and adb reverse tcp:3000 tcp:3000 is active.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts'), backgroundColor: const Color(0xFF0F766E)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Enter contact code'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _addContact, child: const Text('Add contact (send invite)')),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadContacts,
                child: ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final c = _contacts[index];
                    final accepted = c['accepted'] == true;
                    return ListTile(
                      leading: CircleAvatar(child: Text((c['name'] ?? c['userCode'] ?? 'C')[0])),
                      title: Text(c['name'] ?? c['userCode'] ?? 'Contact'),
                      subtitle: Text(accepted ? 'Accepted' : 'Pending'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!accepted)
                            TextButton(
                              onPressed: () => _resendInvite(c['id']),
                              child: const Text('Resend'),
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _removeContact(c['id']),
                            tooltip: 'Remove contact',
                          ),
                        ],
                      ),
                      onTap: () {
                        // show details
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(c['name'] ?? c['userCode'] ?? 'Contact'),
                            content: Text('Status: ${accepted ? 'Accepted' : 'Pending'}\nCode: ${c['userCode'] ?? ''}'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
