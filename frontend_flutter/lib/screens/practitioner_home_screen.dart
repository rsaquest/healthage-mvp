import 'package:flutter/material.dart';
import '../app_state.dart';
import 'chat_screen.dart';

class PractitionerHomeScreen extends StatelessWidget {
  const PractitionerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final welcomeName = state.currentUser?.name ?? 'Doctor';

        return Scaffold(
          backgroundColor: const Color(0xFFF5FBFA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome, $welcomeName', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('You have 2 pending care requests today.', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      ],
                    ),
                  ),
                  const Text('Platform Updates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFDDE7E4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Caregiver Photo Upload: Now active! Please upload evidence of service completion for instant payout verification.',
                          style: TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.5),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hospital Pilot: 3 top Lagos private hospitals aligned for post-discharge recovery integration.',
                          style: TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Pending Requests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (state.latestBooking != null && !state.latestBooking!.caregiverCompleted)
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state.latestBooking!.serviceType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                                  child: Text('Pending', style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('Patient: ${state.latestBooking!.patientName}'),
                            Text('Location: ${state.latestBooking!.location}'),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                if (!state.latestBooking!.caregiverAccepted && !state.latestBooking!.caregiverRejected) ...[
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
                                      onPressed: () => state.caregiverAcceptService(),
                                      child: const Text('Accept'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => state.caregiverRejectService(),
                                      child: const Text('Decline'),
                                    ),
                                  ),
                                ] else if (state.latestBooking!.caregiverAccepted) ...[
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => state.markArrival(),
                                      icon: const Icon(Icons.location_on),
                                      label: const Text('Mark Arrived'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                                      onPressed: () => state.markCompletion(),
                                      icon: const Icon(Icons.check),
                                      label: const Text('Complete'),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No active requests.', style: TextStyle(color: Colors.grey)))),
                  const SizedBox(height: 24),
                  const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _QuickAction(icon: Icons.chat_bubble_outline, label: 'Messages', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))),
                      _QuickAction(icon: Icons.calendar_today, label: 'Schedule', onTap: () {}),
                      _QuickAction(icon: Icons.history, label: 'Past Visits', onTap: () {}),
                      _QuickAction(icon: Icons.person_outline, label: 'Profile', onTap: () {}),
                    ],
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0F766E), size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
