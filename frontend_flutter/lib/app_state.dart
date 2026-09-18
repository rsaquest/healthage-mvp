import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'backend_config.dart';

class UserProfile {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String? userCode;

  const UserProfile({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.userCode,
  });

  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? role,
    String? userCode,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      userCode: userCode ?? this.userCode,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final parsedId = idValue is int ? idValue : int.tryParse(idValue?.toString() ?? '');
    return UserProfile(
      id: parsedId,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      role: json['role']?.toString() ?? 'Patient',
      userCode: json['userCode']?.toString(),
    );
  }
}

class BookingRequest {
  final String patientName;
  final String serviceType;
  final String practitionerName;
  final String location;
  final DateTime preferredDate;
  final TimeOfDay preferredTime;
  final String caregiverImageUrl;
  final bool videoCheckinRequested;
  final bool caregiverArrived;
  final bool caregiverCompleted;
  final bool caregiverAccepted;
  final bool caregiverRejected;
  final bool paymentConfirmed;
  final String paymentMethod;
  final bool deliveryConfirmed;
  final String completionPhotoUrl;
  final int caregiverRating;
  final String eta;

  const BookingRequest({
    required this.patientName,
    required this.serviceType,
    required this.practitionerName,
    required this.location,
    required this.preferredDate,
    required this.preferredTime,
    this.caregiverImageUrl = 'https://via.placeholder.com/300x200.png?text=Caregiver+En+Route',
    this.videoCheckinRequested = false,
    this.caregiverArrived = false,
    this.caregiverCompleted = false,
    this.caregiverAccepted = false,
    this.caregiverRejected = false,
    this.paymentConfirmed = false,
    this.paymentMethod = '',
    this.deliveryConfirmed = false,
    this.completionPhotoUrl = '',
    this.caregiverRating = 0,
    this.eta = '15 minutes',
  });

  BookingRequest copyWith({
    String? caregiverImageUrl,
    bool? videoCheckinRequested,
    bool? caregiverArrived,
    bool? caregiverCompleted,
    bool? caregiverAccepted,
    bool? caregiverRejected,
    bool? paymentConfirmed,
    String? paymentMethod,
    bool? deliveryConfirmed,
    String? completionPhotoUrl,
    int? caregiverRating,
    String? eta,
  }) {
    return BookingRequest(
      patientName: patientName,
      serviceType: serviceType,
      practitionerName: practitionerName,
      location: location,
      preferredDate: preferredDate,
      preferredTime: preferredTime,
      caregiverImageUrl: caregiverImageUrl ?? this.caregiverImageUrl,
      videoCheckinRequested: videoCheckinRequested ?? this.videoCheckinRequested,
      caregiverArrived: caregiverArrived ?? this.caregiverArrived,
      caregiverCompleted: caregiverCompleted ?? this.caregiverCompleted,
      caregiverAccepted: caregiverAccepted ?? this.caregiverAccepted,
      caregiverRejected: caregiverRejected ?? this.caregiverRejected,
      paymentConfirmed: paymentConfirmed ?? this.paymentConfirmed,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryConfirmed: deliveryConfirmed ?? this.deliveryConfirmed,
      completionPhotoUrl: completionPhotoUrl ?? this.completionPhotoUrl,
      caregiverRating: caregiverRating ?? this.caregiverRating,
      eta: eta ?? this.eta,
    );
  }
}

enum RequestStatus { idle, requested, arrived, completed }

class MedicationOrder {
  final String name;
  final String price;
  final String logisticsFee;
  final String status;
  final String paymentMethod;
  final bool deliveryConfirmed;
  final int reviewRating;
  final String deliveryEta;

  MedicationOrder({
    required this.name,
    required this.price,
    required this.logisticsFee,
    required this.status,
    required this.paymentMethod,
    required this.deliveryConfirmed,
    required this.reviewRating,
    required this.deliveryEta,
  });

  MedicationOrder copyWith({
    String? status,
    String? paymentMethod,
    bool? deliveryConfirmed,
    int? reviewRating,
    String? deliveryEta,
  }) {
    return MedicationOrder(
      name: name,
      price: price,
      logisticsFee: logisticsFee,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryConfirmed: deliveryConfirmed ?? this.deliveryConfirmed,
      reviewRating: reviewRating ?? this.reviewRating,
      deliveryEta: deliveryEta ?? this.deliveryEta,
    );
  }
}

class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;

  ChatMessage({required this.sender, required this.message, required this.timestamp});
}

class MedicalHistoryEntry {
  final String date;
  final String title;
  final String details;

  const MedicalHistoryEntry({required this.date, required this.title, required this.details});
}

class AppState extends ChangeNotifier {
  bool _backgroundServicesStarted = false;

  AppState._internal() {
    _users.addAll([
      const UserProfile(id: 1, name: 'Dr. Ada Okafor', email: 'ada@healthage.com', password: 'demo123', role: 'Practitioner', userCode: 'AO-001'),
      const UserProfile(id: 2, name: 'Nurse Tolu Adebayo', email: 'tolu@healthage.com', password: 'demo123', role: 'Caregiver', userCode: 'TA-002'),
      const UserProfile(id: 3, name: 'Admin Maya', email: 'maya@healthage.com', password: 'demo123', role: 'Admin', userCode: 'MA-003'),
      const UserProfile(id: 4, name: 'Parent Jenna', email: 'jenna@healthage.com', password: 'demo123', role: 'Parent', userCode: 'JE-004'),
      const UserProfile(id: 5, name: 'Patient Daniel', email: 'daniel@healthage.com', password: 'demo123', role: 'Patient', userCode: 'DA-005'),
    ]);
  }

  void startBackgroundServices() {
    if (_backgroundServicesStarted) return;
    _backgroundServicesStarted = true;
    _initMessaging();
  }

  // Initialize messaging (FCM) if available; fallback to mock token registration.
  void _initMessaging() async {
    try {
      await Firebase.initializeApp();
      final fcm = FirebaseMessaging.instance;
      await fcm.requestPermission();
      final token = await fcm.getToken();
      if (token != null) {
        registerDeviceToken(token);
      }
      FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
        final title = msg.notification?.title ?? 'HealthAge';
        final body = msg.notification?.body ?? '';
        if (msg.data.isNotEmpty) {
          final data = Map<String, dynamic>.from(msg.data);
          if (data['info'] == 'contact_accept') {
            // lightweight notification for contact acceptance
            _lastNotificationMessage = body.isNotEmpty ? body : '${data['name'] ?? 'A contact'} accepted your invite';
            notifyListeners();
          } else if (data['sosId'] != null) {
            // record last SOS payload (data-driven) and notify listeners
            _lastSos = data;
            _sosDialogShown = false;
            notifyListeners();
            // show persistent local notification
            try {
              final sid = int.tryParse(_lastSos?['sosId']?.toString() ?? '') ?? DateTime.now().millisecondsSinceEpoch;
              NotificationService().showPersistentAlert(sid, title, body);
            } catch (_) {}
          }
        }
        sendMessage('[PUSH] $title: $body');
      });
    } catch (e) {
      // Fallback: create a mock token and register it so backend can log notifications during development
      final rnd = DateTime.now().millisecondsSinceEpoch.toString() + '-' + (Random().nextInt(1 << 30)).toString();
      final mockToken = 'mock-$rnd';
      try {
        final fallbackId = _currentUserId ?? currentUser?.id ?? 'guest';
        await http.post(Uri.parse('${BackendConfig.httpBase}/api/register-device'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'userId': fallbackId, 'token': mockToken}));
      } catch (_) {}
    }
    // Auto-identify a demo user on startup so the backend returns a persistent numeric userId
    try {
      if (_currentUserId == null) {
        final demoResp = await http.post(Uri.parse('${BackendConfig.httpBase}/api/users/identify'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'email': 'demo@healthage.com', 'name': 'Demo User'}));
        if (demoResp.statusCode == 200) {
          final d = jsonDecode(demoResp.body);
          _currentUserId = d['user'] != null ? d['user']['id'] as int : null;
        }
      }
    } catch (_) {}
    await loadServerPractitioners();
    // initialize realtime websocket connection
    _initRealtime();
  }

  WebSocketChannel? _channel;
  bool _isConnecting = false;

  void _initRealtime() async {
    if (_isConnecting) return;
    _isConnecting = true;
    try {
      final wsUrl = BackendConfig.wsUrl;
      if (kIsWeb) {
        _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      } else {
        _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      }
      _channel?.stream.listen((msg) {
        try {
          final data = jsonDecode(msg as String) as Map<String, dynamic>;
          final type = data['type'];
          if (type == 'contact_accept') {
            _lastNotificationMessage = data['contact'] != null ? '${data['contact']['name']} accepted your invite' : 'A contact accepted your invite';
            notifyListeners();
          } else if (type == 'sos') {
            _lastSos = data;
            _sosDialogShown = false;
            NotificationService().showPersistentAlert((data['sosId'] ?? DateTime.now().millisecondsSinceEpoch) as int, data['typeLabel'] ?? 'SOS', data['message'] ?? 'Emergency');
            notifyListeners();
          } else if (type == 'sos_ack') {
            sendMessage('[INFO] SOS ${data['sosId']} acknowledged by ${data['byUserId']}');
            notifyListeners();
          }
        } catch (e) {}
      }, onDone: () {
        _channel = null;
        _isConnecting = false;
        Future.delayed(const Duration(seconds: 15), () => _initRealtime());
      }, onError: (_) {
        _channel = null;
        _isConnecting = false;
        Future.delayed(const Duration(seconds: 15), () => _initRealtime());
      });
      _registerWebSocket();
    } catch (e) {
      _isConnecting = false;
      Future.delayed(const Duration(seconds: 15), () => _initRealtime());
    }
  }

  void _registerWebSocket() {
    if (_channel == null) return;
    final reg = jsonEncode({'type': 'register', 'userId': _currentUserId ?? (currentUser?.id ?? 'guest')});
    try {
      _channel?.sink.add(reg);
    } catch (e) {}
  }

  void registerDeviceToken(String token) async {
    final backend = BackendConfig.httpBase;
    final userId = _currentUserId ?? (currentUser?.id ?? 'guest');
    try {
      await http.post(Uri.parse('$backend/api/register-device'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'userId': userId, 'token': token}));
    } catch (e) {
      // ignore
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  Map<String, dynamic>? _lastSos;
  bool _sosDialogShown = false;
  String? _lastNotificationMessage;
  bool _lastNotificationShown = false;

  Map<String, dynamic>? get lastSos => _lastSos;
  bool get sosDialogShown => _sosDialogShown;

  void markSosDialogShown() {
    _sosDialogShown = true;
    notifyListeners();
  }

  void clearLastSos() {
    _lastSos = null;
    _sosDialogShown = false;
    notifyListeners();
  }

  String? get lastNotificationMessage => _lastNotificationMessage;

  void markLastNotificationShown() {
    _lastNotificationShown = true;
    _lastNotificationMessage = null;
    notifyListeners();
  }

  int? _currentUserId;
  int? get currentUserId => _currentUserId;

  final List<UserProfile> _serverPractitioners = [];
  List<UserProfile> get serverPractitioners => List.unmodifiable(_serverPractitioners);

  Future<void> _identifyUserOnServer() async {
    if (currentUser == null) return;
    try {
      final resp = await http.post(Uri.parse('${BackendConfig.httpBase}/api/users/identify'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({
        'email': currentUser!.email,
        'name': currentUser!.name,
        'role': currentUser!.role,
        'userCode': currentUser!.userCode,
      }));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['user'] != null) {
          final backendUser = UserProfile.fromJson(data['user'] as Map<String, dynamic>);
          _currentUserId = backendUser.id;
          _currentUser = _currentUser?.copyWith(
            id: backendUser.id,
            userCode: backendUser.userCode,
            role: backendUser.role,
          );
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _registerUserOnServer() async {
    if (currentUser == null) return;
    try {
      final resp = await http.post(Uri.parse('${BackendConfig.httpBase}/api/register'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({
        'email': currentUser!.email,
        'name': currentUser!.name,
        'role': currentUser!.role,
        'userCode': currentUser!.userCode,
      }));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['user'] != null) {
          final backendUser = UserProfile.fromJson(data['user'] as Map<String, dynamic>);
          _currentUserId = backendUser.id;
          _currentUser = _currentUser?.copyWith(
            id: backendUser.id,
            userCode: backendUser.userCode,
            role: backendUser.role,
          );
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> loadServerPractitioners() async {
    try {
      final resp = await http.get(Uri.parse('${BackendConfig.httpBase}/api/practitioners'));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final fetched = (data['data'] as List<dynamic>).map((item) => UserProfile.fromJson(item as Map<String, dynamic>)).toList();
        _serverPractitioners.clear();
        _serverPractitioners.addAll(fetched);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> ackSos(int sosId) async {
    final userId = _currentUserId ?? (currentUser?.id ?? 0);
    try {
      final resp = await http.post(Uri.parse('${BackendConfig.httpBase}/api/emergency/$sosId/ack'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'userId': userId}));
      if (resp.statusCode == 200) {
        // cancel local notification
        NotificationService().cancel(sosId);
        clearLastSos();
      }
    } catch (e) {
      // ignore
    }
  }

  static final AppState instance = AppState._internal();

  factory AppState() => instance;

  final List<UserProfile> _users = [];
  bool _isAuthenticated = false;
  UserProfile? _currentUser;
  BookingRequest? _latestBooking;
  RequestStatus _requestStatus = RequestStatus.idle;
  int _caregiverRating = 0;
  String? _lastError;
  final List<MedicationOrder> _medicationOrders = [];
  final List<ChatMessage> _chatMessages = [];
  final List<MedicalHistoryEntry> _medicalHistory = const [
    MedicalHistoryEntry(
      date: '22 Jul 2026',
      title: 'Post-op nursing visit',
      details: 'Wound check, dressing change, and medication review.',
    ),
    MedicalHistoryEntry(
      date: '19 Jul 2026',
      title: 'Blood pressure assessment',
      details: 'Recorded 130/80 mmHg and adjusted medication plan.',
    ),
    MedicalHistoryEntry(
      date: '15 Jul 2026',
      title: 'Teleconsultation note',
      details: 'Discussed recovery plan and follow-up labs.',
    ),
    MedicalHistoryEntry(
      date: '12 Jul 2026',
      title: 'Physical therapy progress',
      details: 'Mobility exercises and pain management guidance.',
    ),
  ];

  bool get isAuthenticated => _isAuthenticated;
  UserProfile? get currentUser => _currentUser;
  List<UserProfile> get users => List.unmodifiable(_users);
  List<UserProfile> get visiblePractitioners => _users.where((user) => user.role == 'Practitioner' || user.role == 'Caregiver').toList();

  List<UserProfile> get availablePractitioners {
    final unique = <String, UserProfile>{};
    for (final practitioner in _serverPractitioners) {
      if (practitioner.id != null) {
        unique['id:${practitioner.id}'] = practitioner;
      } else if (practitioner.userCode != null) {
        unique['code:${practitioner.userCode}'] = practitioner;
      }
    }
    for (final practitioner in visiblePractitioners) {
      if (practitioner.id != null) {
        unique.putIfAbsent('id:${practitioner.id}', () => practitioner);
      } else if (practitioner.userCode != null) {
        unique.putIfAbsent('code:${practitioner.userCode}', () => practitioner);
      }
    }
    return List.unmodifiable(unique.values);
  }

  BookingRequest? get latestBooking => _latestBooking;
  RequestStatus get requestStatus => _requestStatus;
  int get caregiverRating => _caregiverRating;
  String? get lastError => _lastError;
  List<MedicationOrder> get medicationOrders => List.unmodifiable(_medicationOrders);
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);
  List<MedicalHistoryEntry> get medicalHistory => List.unmodifiable(_medicalHistory);

  List<Map<String, String>> get availableMedications => const [
    {'name': 'Paracetamol 500mg', 'price': '₦1,200', 'details': 'Pain relief, fever reducer.'},
    {'name': 'Amoxicillin 250mg', 'price': '₦1,800', 'details': 'Antibiotic for infections.'},
    {'name': 'Metformin 500mg', 'price': '₦2,500', 'details': 'Blood sugar regulation.'},
    {'name': 'Lisinopril 10mg', 'price': '₦2,000', 'details': 'Blood pressure control.'},
    {'name': 'Vitamin D 1000 IU', 'price': '₦950', 'details': 'Bone and immune support.'},
    {'name': 'Ibuprofen 200mg', 'price': '₦1,100', 'details': 'Inflammation and pain relief.'},
    {'name': 'Cefalexin 500mg', 'price': '₦2,100', 'details': 'Broad-spectrum antibiotic.'},
    {'name': 'Omeprazole 20mg', 'price': '₦1,700', 'details': 'Stomach acid control and ulcer relief.'},
    {'name': 'Salbutamol Inhaler', 'price': '₦3,400', 'details': 'Bronchodilator for asthma and wheezing.'},
    {'name': 'Atorvastatin 20mg', 'price': '₦2,800', 'details': 'Cholesterol management.'},
    {'name': 'Amlodipine 5mg', 'price': '₦2,300', 'details': 'Helps control high blood pressure.'},
    {'name': 'Loratadine 10mg', 'price': '₦1,050', 'details': 'Seasonal allergy relief.'},
  ];

  bool registerUser({required String name, required String email, required String password, required String role}) {
    if (email.trim().isEmpty || password.trim().isEmpty || name.trim().isEmpty) {
      _lastError = 'Please fill in your name, email, and password.';
      notifyListeners();
      return false;
    }

    final existing = _users.any((user) => user.email.toLowerCase() == email.trim().toLowerCase());
    if (existing) {
      _lastError = 'An account with that email already exists.';
      notifyListeners();
      return false;
    }

    _users.add(UserProfile(name: name.trim(), email: email.trim(), password: password, role: role, userCode: email.trim().split('@').first.toUpperCase()));
    _currentUser = _users.last;
    _isAuthenticated = true;
    _lastError = null;
    _registerUserOnServer();
    loadServerPractitioners();
    startBackgroundServices();
    _registerWebSocket();
    notifyListeners();
    return true;
  }

  bool loginUser({required String email, required String password}) {
    final user = _users.firstWhere(
      (entry) => entry.email.toLowerCase() == email.trim().toLowerCase(),
      orElse: () => const UserProfile(name: '', email: '', password: '', role: ''),
    );

    if (user.email.isEmpty || user.password != password) {
      _lastError = 'Please register first or check your sign-in details.';
      _isAuthenticated = false;
      _currentUser = null;
      notifyListeners();
      return false;
    }

    _currentUser = user;
    _isAuthenticated = true;
    _lastError = null;
    _identifyUserOnServer();
    loadServerPractitioners();
    startBackgroundServices();
    _registerWebSocket();
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
    _lastError = null;
    notifyListeners();
  }

  bool submitBooking({
    required String patientName,
    required String serviceType,
    required String practitionerName,
    required String location,
    required DateTime preferredDate,
    required TimeOfDay preferredTime,
  }) {
    if (!_isAuthenticated) {
      _lastError = 'Please sign in before requesting care.';
      notifyListeners();
      return false;
    }

    _latestBooking = BookingRequest(
      patientName: patientName,
      serviceType: serviceType,
      practitionerName: practitionerName,
      location: location,
      preferredDate: preferredDate,
      preferredTime: preferredTime,
    );
    _requestStatus = RequestStatus.requested;
    _lastError = null;
    notifyListeners();
    return true;
  }

  void requestVideoCheckin() {
    if (_latestBooking == null) return;
    _latestBooking = _latestBooking!.copyWith(videoCheckinRequested: true);
    notifyListeners();
  }

  void caregiverAcceptService() {
    if (_latestBooking == null) return;
    _latestBooking = _latestBooking!.copyWith(caregiverAccepted: true, caregiverRejected: false);
    notifyListeners();
  }

  void caregiverRejectService() {
    if (_latestBooking == null) return;
    _latestBooking = _latestBooking!.copyWith(caregiverAccepted: false, caregiverRejected: true);
    _requestStatus = RequestStatus.idle;
    notifyListeners();
  }

  void caregiverUploadEvidence(String photoUrl) {
    if (_latestBooking == null) return;
    _latestBooking = _latestBooking!.copyWith(completionPhotoUrl: photoUrl);
    notifyListeners();
  }

  void confirmPayment(String method) {
    if (_latestBooking == null) return;
    _latestBooking = _latestBooking!.copyWith(paymentConfirmed: true, paymentMethod: method);
    notifyListeners();
  }

  void confirmDelivery() {
    if (_latestBooking == null) return;
    _latestBooking = _latestBooking!.copyWith(deliveryConfirmed: true);
    notifyListeners();
  }

  void markArrival() {
    if (_latestBooking == null) {
      _requestStatus = RequestStatus.requested;
    } else {
      _requestStatus = RequestStatus.arrived;
      _latestBooking = _latestBooking!.copyWith(caregiverArrived: true);
    }
    notifyListeners();
  }

  void markCompletion() {
    if (_latestBooking != null) {
      _latestBooking = _latestBooking!.copyWith(caregiverCompleted: true);
    }
    _requestStatus = RequestStatus.completed;
    notifyListeners();
  }

  void submitRating(int rating) {
    _caregiverRating = rating;
    if (_latestBooking != null) {
      _latestBooking = _latestBooking!.copyWith(caregiverRating: rating);
    }
    notifyListeners();
  }

  void submitMedicationOrder({
    required String name,
    required String price,
    required String logisticsFee,
    required String paymentMethod,
  }) {
    _medicationOrders.add(MedicationOrder(
      name: name,
      price: price,
      logisticsFee: logisticsFee,
      status: 'Awaiting delivery',
      paymentMethod: paymentMethod,
      deliveryConfirmed: false,
      reviewRating: 0,
      deliveryEta: '30 minutes',
    ));
    notifyListeners();
  }

  void confirmMedicationDelivery(String name) {
    final index = _medicationOrders.indexWhere((order) => order.name == name);
    if (index < 0) return;
    _medicationOrders[index] = _medicationOrders[index].copyWith(status: 'Delivered', deliveryConfirmed: true);
    notifyListeners();
  }

  void reviewMedicationOrder(String name, int rating) {
    final index = _medicationOrders.indexWhere((order) => order.name == name);
    if (index < 0) return;
    _medicationOrders[index] = _medicationOrders[index].copyWith(status: 'Reviewed', reviewRating: rating);
    notifyListeners();
  }

  void sendMessage(String message) {
    if (_currentUser == null) return;
    _chatMessages.add(ChatMessage(sender: _currentUser!.name, message: message, timestamp: DateTime.now()));
    notifyListeners();
  }

  void clearError() {
    _lastError = null;
    notifyListeners();
  }
}
