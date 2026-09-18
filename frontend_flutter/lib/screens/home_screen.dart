import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_state.dart';
import '../backend_config.dart';
import 'admin_screen.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';
import 'medication_screen.dart';
import 'practitioner_list_screen.dart';
import 'telehealth_screen.dart';
import 'tracking_screen.dart';
import 'contacts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _backendBase = BackendConfig.httpBase;
  final TextEditingController _sosMessageController = TextEditingController();

  @override
  void dispose() {
    _sosMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final welcomeName = state.currentUser?.name ?? 'Amina';
        final requestStatusText = state.requestStatus == RequestStatus.arrived
            ? 'Arrived and ready for the visit'
            : state.requestStatus == RequestStatus.completed
                ? 'Visit completed successfully'
                : 'Request in progress';

        return Scaffold(
          backgroundColor: const Color(0xFFF5FBFA),
          appBar: AppBar(
            title: const Text('HealthAge MVP'),
            backgroundColor: const Color(0xFF0F766E),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.group_add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsScreen()));
                },
                tooltip: 'Manage emergency contacts',
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back, $welcomeName', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text('Your loved ones are protected with Care at Home support.', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Recent Updates & Traction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1C2B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, color: Color(0xFF2DD4BF), size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Pilot Result: 150+ registrations and 100% service fulfillment in July-Aug 2026.',
                            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(requestStatusText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(state.latestBooking == null
                              ? 'No active request yet'
                              : 'Home Visit requested with ${state.latestBooking!.practitionerName} at ${state.latestBooking!.location}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('What do you need today?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (state.currentUser?.role == 'Admin')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
                        },
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('Open Admin Dashboard'),
                      ),
                    ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _ServiceCard(
                        title: 'Emergency',
                        icon: Icons.emergency,
                        color: Colors.redAccent,
                        onTap: () {
                          if (!state.isAuthenticated) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
                            return;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackingScreen()));
                        },
                      ),
                      _ServiceCard(
                        title: 'Home Visit',
                        icon: Icons.home,
                        color: Colors.teal,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const PractitionerListScreen()));
                        },
                      ),
                      _ServiceCard(
                        title: 'Telehealth',
                        icon: Icons.video_call,
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const TelehealthScreen()));
                        },
                      ),
                      _ServiceCard(
                        title: 'Medication',
                        icon: Icons.medication,
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicationScreen()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Care Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('• 2 active care requests'),
                          const Text('• 1 emergency responder assigned'),
                          const Text('• Family updates enabled'),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              Icon(Icons.favorite, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Expanded(child: Text('Vital signs monitored continuously')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.latestBooking != null) ...[
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              state.latestBooking!.caregiverImageUrl,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 160,
                                  color: const Color(0xFFE0F2F1),
                                  child: const Center(
                                    child: Icon(Icons.person, size: 60, color: Color(0xFF0F766E)),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Caregiver enroute', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text('Caregiver: ${state.latestBooking!.practitionerName}'),
                                Text('Service: ${state.latestBooking!.serviceType}'),
                                Text('Location: ${state.latestBooking!.location}'),
                                Text('ETA: ${state.latestBooking!.eta}'),
                                const SizedBox(height: 12),
                                if (state.latestBooking!.videoCheckinRequested)
                                  const Text('Video check-in requested', style: TextStyle(color: Colors.green)),
                                if (!state.latestBooking!.videoCheckinRequested && (state.currentUser?.role == 'Patient' || state.currentUser?.role == 'Family'))
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
                                    onPressed: () {
                                      state.requestVideoCheckin();
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video check-in requested')));
                                    },
                                    icon: const Icon(Icons.videocam),
                                    label: const Text('Request video check-in'),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Visit Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                if (state.currentUser?.role == 'Patient' || state.currentUser?.role == 'Family')
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      state.markArrival();
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Arrival confirmed')));
                                    },
                                    icon: const Icon(Icons.check_circle),
                                    label: const Text('Confirm caregiver arrival'),
                                  ),
                                if (state.currentUser?.role == 'Patient' || state.currentUser?.role == 'Family')
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      state.markCompletion();
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completion confirmed')));
                                    },
                                    icon: const Icon(Icons.done_all),
                                    label: const Text('Confirm completion'),
                                  ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(5, (index) {
                                              final rating = index + 1;
                                              return ListTile(
                                                leading: Icon(Icons.star, color: rating >= 4 ? Colors.amber : Colors.grey),
                                                title: Text('$rating star${rating > 1 ? 's' : ''}'),
                                                onTap: () {
                                                  state.submitRating(rating);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Caregiver rated $rating stars')));
                                                },
                                              );
                                            }),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.star),
                                  label: const Text('Rate caregiver'),
                                ),
                                if (state.currentUser?.role == 'Caregiver' && !state.latestBooking!.caregiverAccepted && !state.latestBooking!.caregiverRejected)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                                    onPressed: () {
                                      state.caregiverAcceptService();
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service accepted')));
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text('Accept service'),
                                  ),
                                if (state.currentUser?.role == 'Caregiver' && !state.latestBooking!.caregiverAccepted && !state.latestBooking!.caregiverRejected)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                    onPressed: () {
                                      state.caregiverRejectService();
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service rejected')));
                                    },
                                    icon: const Icon(Icons.close),
                                    label: const Text('Reject service'),
                                  ),
                                if (state.currentUser?.role == 'Caregiver' && state.latestBooking!.caregiverAccepted)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
                                    onPressed: () {
                                      state.caregiverUploadEvidence('https://via.placeholder.com/300x200.png?text=Completion+Proof');
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completion photo uploaded')));
                                    },
                                    icon: const Icon(Icons.photo_camera),
                                    label: const Text('Upload completion photo'),
                                  ),
                              ],
                            ),
                            if (!state.latestBooking!.paymentConfirmed && (state.currentUser?.role == 'Patient' || state.currentUser?.role == 'Family'))
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Choose payment option', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 12),
                                              const ListTile(
                                                leading: Icon(Icons.credit_card),
                                                title: Text('Card payment'),
                                                subtitle: Text('Pay for drug and logistics immediately'),
                                              ),
                                              const ListTile(
                                                leading: Icon(Icons.money),
                                                title: Text('Pay on delivery'),
                                                subtitle: Text('Pay when the medication arrives'),
                                              ),
                                              const SizedBox(height: 12),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), minimumSize: const Size.fromHeight(50)),
                                                onPressed: () {
                                                  state.confirmPayment('Card payment');
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment confirmed')));
                                                },
                                                child: const Text('Confirm Card Payment'),
                                              ),
                                              const SizedBox(height: 8),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black, minimumSize: const Size.fromHeight(50)),
                                                onPressed: () {
                                                  state.confirmPayment('Pay on delivery');
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment option selected')));
                                                },
                                                child: const Text('Confirm Pay on Delivery'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.payment),
                                  label: const Text('Choose payment option'),
                                ),
                              ),
                            if (state.latestBooking!.paymentConfirmed)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text('Payment confirmed: ${state.latestBooking!.paymentMethod}. Caregiver has been notified.', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            if (!state.latestBooking!.paymentConfirmed)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text('Payment pending. Choose a payment option to continue.', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                              ),
                            if (state.latestBooking!.deliveryConfirmed)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text('Delivery confirmed ✅', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ),
                            if (state.latestBooking!.completionPhotoUrl.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Completion photo evidence', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Image.network(state.latestBooking!.completionPhotoUrl, height: 120, fit: BoxFit.cover),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if ((state.currentUser?.role == 'Caregiver' || state.currentUser?.role == 'Patient' || state.currentUser?.role == 'Family'))
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Digital medical history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              for (final entry in state.medicalHistory)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${entry.date} • ${entry.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(entry.details, style: const TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Medication orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            for (final order in state.medicationOrders)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(order.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Text('Price: ${order.price} + Logistics: ${order.logisticsFee}'),
                                          Text('Status: ${order.status}'),
                                          Text('Payment: ${order.paymentMethod}'),
                                          if (order.deliveryConfirmed) const Text('Delivered', style: TextStyle(color: Colors.green)),
                                        ],
                                      ),
                                    ),
                                    if (!order.deliveryConfirmed)
                                      ElevatedButton(
                                        onPressed: () {
                                          AppState.instance.confirmMedicationDelivery(order.name);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medication delivery confirmed')));
                                        },
                                        child: const Text('Confirm delivery'),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: const Icon(Icons.chat_bubble_outline, color: Colors.teal),
                      title: const Text('In-app chat'),
                      subtitle: const Text('Message your caregiver or family'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'home_sos_button',
            onPressed: () => _onSosPressed(state),
            backgroundColor: const Color(0xFFE53935),
            icon: const Icon(Icons.sos, color: Colors.white),
            label: const Text('SOS Emergency', style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }

  void _onSosPressed(AppState state) {
    if (!state.isAuthenticated) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Send Emergency Alert'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _sosMessageController,
                decoration: const InputDecoration(labelText: 'Optional message'),
              ),
              const SizedBox(height: 12),
              const Text('Choose alert type', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => _sendSos(state, 'medical_emergency'),
              child: const Text('Medical Emergency'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => _sendSos(state, 'require_attention'),
              child: const Text('Require Attention'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendSos(AppState state, String type) async {
    final message = _sosMessageController.text.trim();
    Navigator.pop(context);
    final patientId = state.currentUser?.id ?? 0;
    final uri = Uri.parse('$_backendBase/api/emergency');
    try {
      final resp = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'patientId': patientId, 'type': type, 'message': message}));
      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SOS sent')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send SOS: ${resp.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending SOS: $e')));
    }
    _sosMessageController.clear();
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, size: 36, color: color),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
