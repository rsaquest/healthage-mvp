import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_state.dart';
import '../backend_config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  String? _recipientName;
  int? _recipientContactId;
  final _backend = BackendConfig.httpBase;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = AppState.instance.chatMessages;

    return Scaffold(
      appBar: AppBar(
        title: Text(_recipientName == null ? 'In-app chat' : 'Chat — ${_recipientName!}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              final user = AppState.instance.currentUser?.name ?? 'You';
              AppState.instance.sendMessage('$user buzzed the care team');
              setState(() {});
            },
          ),
        ],
      ),
      body: _recipientName == null ? _buildChoiceBody() : _buildChatBody(messages),
    );
  }

  Widget _buildChoiceBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), minimumSize: const Size.fromHeight(56)),
            onPressed: () {
              setState(() {
                _recipientName = 'HealthAge Support';
              });
            },
            icon: const Icon(Icons.support_agent),
            label: const Text('Chat with HealthAge'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size.fromHeight(56)),
            onPressed: _selectLovedOne,
            icon: const Icon(Icons.people),
            label: const Text('Chat with Your Loved Ones'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBody(List messages) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final item = messages[index];
              final isOwn = item.sender == AppState.instance.currentUser?.name;
              return Align(
                alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isOwn ? const Color(0xFF0F766E) : const Color(0xFFE9F7F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(item.message, style: TextStyle(color: isOwn ? Colors.white : Colors.black87)),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(hintText: 'Type your message', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18)),
                onPressed: () {
                  final message = _messageController.text.trim();
                  if (message.isEmpty) return;
                  AppState.instance.sendMessage('${AppState.instance.currentUser?.name ?? 'You'}: $message');
                  _messageController.clear();
                  setState(() {});
                },
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectLovedOne() async {
    final pid = AppState.instance.currentUserId ?? (AppState.instance.currentUser?.id ?? 0);
    final uri = Uri.parse('$_backend/api/emergency-contacts?patientId=$pid');
    try {
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final contacts = data['contacts'] as List<dynamic>;
        if (contacts.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No registered loved ones found')));
          return;
        }
        final selected = await showDialog<dynamic>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Select a contact'),
            children: contacts.map((c) => SimpleDialogOption(onPressed: () => Navigator.pop(context, c), child: Text(c['name'] ?? c['userCode'] ?? 'Contact'))).toList(),
          ),
        );
        if (selected != null) {
          setState(() {
            _recipientName = selected['name'] ?? selected['userCode'];
            _recipientContactId = selected['id'];
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to reach backend. Ensure the server is running and adb reverse tcp:3000 tcp:3000 is active.')));
    }
  }
}
