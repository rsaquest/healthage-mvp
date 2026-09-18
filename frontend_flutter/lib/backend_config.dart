import 'package:flutter/foundation.dart';

class BackendConfig {
  // For web, use localhost. For Android/iOS devices, use localhost with adb reverse
  // set up by running: adb reverse tcp:3000 tcp:3000
  static String get httpBase => kIsWeb ? 'http://localhost:3000' : 'http://127.0.0.1:3000';
  static String get wsUrl => kIsWeb ? 'ws://localhost:3000/ws' : 'ws://127.0.0.1:3000/ws';
}
