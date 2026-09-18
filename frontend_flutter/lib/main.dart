import 'package:flutter/material.dart';
import 'app_state.dart';
import 'services/notification_service.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/practitioner_list_screen.dart';
import 'screens/telehealth_screen.dart';
import 'screens/map_tracking_screen.dart';
import 'screens/medication_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/recipient_invites_screen.dart';
import 'screens/practitioner_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize notification service
  NotificationService().init().catchError((_) {});
  runApp(const HealthAge());
}

class HealthAge extends StatelessWidget {
  const HealthAge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthAge MVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F766E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ),
      home: const AuthScreen(),
      routes: {
        '/auth': (_) => const AuthScreen(),
        '/invites': (_) => const RecipientInvitesScreen(),
        '/main': (_) => const MainNavigation(),
        '/admin': (_) => const AdminScreen(),
        '/medication': (_) => const MedicationScreen(),
        '/chat': (_) => const ChatScreen(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final isPractitioner = state.currentUser?.role == 'Practitioner' || state.currentUser?.role == 'Caregiver';

        final List<Widget> pages = [
          isPractitioner ? const PractitionerHomeScreen() : const HomeScreen(),
          const BookingScreen(),
          const PractitionerListScreen(),
          const TelehealthScreen(),
          const MapTrackingScreen(),
        ];

        // show SOS dialog if newly received
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final sos = state.lastSos;
          final note = state.lastNotificationMessage;
          if (note != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(note)));
            state.markLastNotificationShown();
          }
          if (sos != null && !state.sosDialogShown) {
            state.markSosDialogShown();
            final sosId = int.tryParse(sos['sosId']?.toString() ?? '') ?? (DateTime.now().millisecondsSinceEpoch);
            final patientName = sos['patientName'] ?? sos['patientId']?.toString() ?? 'A patient';
            final type = sos['type'] == 'medical_emergency' ? 'Medical Emergency' : 'Requires Attention';
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('$patientName — $type'),
                  content: Text(sos['message'] ?? ''),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Later')),
                    ElevatedButton(
                      onPressed: () async {
                        await state.ackSos(sosId);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Acknowledged')));
                      },
                      child: const Text('Acknowledge'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                      },
                      child: const Text('Message'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calling...')));
                      },
                      child: const Text('Call'),
                    ),
                  ],
                );
              },
            );
          }
        });

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Book'),
              NavigationDestination(icon: Icon(Icons.health_and_safety), label: 'Care'),
              NavigationDestination(icon: Icon(Icons.video_call), label: 'Consult'),
              NavigationDestination(icon: Icon(Icons.map), label: 'Track'),
            ],
          ),
        );
      },
    );
  }
}
