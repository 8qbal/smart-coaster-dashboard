import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/sensor_data.dart';
import '../services/firebase_service.dart';

/// Manages sensor data state and connection status.
class SensorProvider extends ChangeNotifier {
  // Nullable — not created on Linux where Firebase is unavailable
  FirebaseService? _firebaseService;

  SensorData? _currentData;
  bool _isOnline = false;
  DateTime? _lastUpdateTime;
  StreamSubscription? _dataSubscription;
  Timer? _onlineCheckTimer;

  static const Duration offlineThreshold = Duration(seconds: 60);
  static const int maxDataPoints = 720;

  final List<SensorData> _history = [];

  // ─── Getters ────────────────────────────────────────────────
  SensorData? get currentData => _currentData;
  bool get isOnline => _isOnline;
  bool get hasData => _currentData != null;
  DateTime? get lastUpdateTime => _lastUpdateTime;
  List<SensorData> get history => List.unmodifiable(_history);

  String get lastUpdatedText {
    if (_lastUpdateTime == null) return 'Never';
    final diff = DateTime.now().difference(_lastUpdateTime!);
    if (diff.inSeconds < 5) return 'Just now';
    if (diff.inSeconds < 60) return '${diff.inSeconds} seconds ago';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m minute${m > 1 ? 's' : ''} ago';
    }
    return '${_lastUpdateTime!.hour.toString().padLeft(2, '0')}:'
        '${_lastUpdateTime!.minute.toString().padLeft(2, '0')}:'
        '${_lastUpdateTime!.second.toString().padLeft(2, '0')}';
  }

  // ─── Lifecycle ──────────────────────────────────────────────

  void initialize() {
    // Linux desktop: Firebase not supported — UI-only mode with mock data
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
      print('ℹ️ Linux: Firebase skipped. Showing UI with placeholder data.');
      _injectMockData();
      _startOnlineChecker();
      return;
    }

    _firebaseService = FirebaseService();
    _firebaseService!.startListening();

    _dataSubscription = _firebaseService!.dataStream.listen(
      _onDataReceived,
      onError: (error) {
        print('SensorProvider error: $error');
        _setOffline();
      },
    );

    _startOnlineChecker();
    print('✅ SensorProvider initialized');
  }

  /// Inject mock sensor data so the UI looks populated on Linux.
  void _injectMockData() {
    final now = DateTime.now().millisecondsSinceEpoch;
    // Simulate 20 historical readings
    for (int i = 20; i >= 0; i--) {
      _history.add(SensorData.fromMap({
        'temp': 28.0 + (i % 5) * 0.5,
        'humidity': 62.0 + (i % 7) * 1.0,
        'distance': 3.2,
        'bottle_present': true,
        'timestamp': now - i * 5000,
      }));
    }
    _currentData = _history.last;
    _lastUpdateTime = DateTime.now();
    _isOnline = true;
    notifyListeners();
  }

  void _startOnlineChecker() {
    _onlineCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkOnlineStatus(),
    );
  }

  void _onDataReceived(SensorData data) {
    _currentData = data;
    _lastUpdateTime = DateTime.now();
    _isOnline = true;

    _history.add(data);
    if (_history.length > maxDataPoints) {
      _history.removeAt(0);
    }

    notifyListeners();
  }

  void _checkOnlineStatus() {
    if (_lastUpdateTime == null) return;
    final diff = DateTime.now().difference(_lastUpdateTime!);
    if (diff > offlineThreshold && _isOnline) {
      _setOffline();
    }
    notifyListeners();
  }

  void _setOffline() {
    _isOnline = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _onlineCheckTimer?.cancel();
    _firebaseService?.dispose();
    super.dispose();
  }
}
