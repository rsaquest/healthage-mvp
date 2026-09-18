import 'package:flutter/foundation.dart';

class BackendConfig {
  static const String productionHttpBase = 'https://healthage-backend.onrender.com';
  static const String productionWsUrl = 'wss://healthage-backend.onrender.com/ws';

  static String get httpBase => kReleaseMode
      ? productionHttpBase
      : (kIsWeb ? 'http://localhost:3000' : 'http://127.0.0.1:3000');

  static String get wsUrl => kReleaseMode
      ? productionWsUrl
      : (kIsWeb ? 'ws://localhost:3000/ws' : 'ws://127.0.0.1:3000/ws');
}
