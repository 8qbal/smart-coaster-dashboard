import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_data.dart';

/// Service that handles real-time data subscription from Firebase RTDB.
/// Uses lazy initialization so FirebaseDatabase.instance is only accessed
/// when startListening() is called, not at construction time.
class FirebaseService {
  static const String _smartCoasterPath = 'SmartCoaster/status';

  // Lazy: only accessed when startListening() is called
  late final FirebaseDatabase _database = FirebaseDatabase.instance;

  StreamSubscription<DatabaseEvent>? _subscription;

  final StreamController<SensorData> _dataController =
      StreamController<SensorData>.broadcast();

  Stream<SensorData> get dataStream => _dataController.stream;
  bool get isListening => _subscription != null;

  void startListening() {
    if (_subscription != null) stopListening();

    final ref = _database.ref(_smartCoasterPath);

    _subscription = ref.onValue.listen(
      (DatabaseEvent event) {
        final data = event.snapshot.value;
        if (data != null && data is Map) {
          final sensorData = SensorData.fromMap(data);
          _dataController.add(sensorData);
          print('📊 Data received: $sensorData');
        }
      },
      onError: (error) {
        print('❌ Firebase listener error: $error');
        _dataController.addError(error);
      },
    );

    print('🔊 Started listening to: $_smartCoasterPath');
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    print('🔇 Stopped listening to Firebase');
  }

  void dispose() {
    stopListening();
    _dataController.close();
  }
}
