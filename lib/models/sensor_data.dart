/// Data model for Smart Coaster sensor readings.
/// Maps to the Firebase Realtime Database structure at SmartCoaster/status.
class SensorData {
  final double temperature;
  final double humidity;
  final double distance;
  final bool bottlePresent;
  final int timestamp;

  const SensorData({
    required this.temperature,
    required this.humidity,
    required this.distance,
    required this.bottlePresent,
    required this.timestamp,
  });

  /// Distance threshold for bottle detection (in cm).
  static const double bottleDetectionDistance = 5.0;

  /// Create SensorData from Firebase snapshot map.
  factory SensorData.fromMap(Map<dynamic, dynamic> map) {
    final double temp = (map['temp'] ?? 0).toDouble();
    final double humidity = (map['humidity'] ?? 0).toDouble();
    final double distance = (map['distance'] ?? 0).toDouble();
    final bool bottlePresent =
        map['bottle_present'] == true || distance < bottleDetectionDistance;
    final int timestamp = map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch;

    return SensorData(
      temperature: temp,
      humidity: humidity,
      distance: distance,
      bottlePresent: bottlePresent,
      timestamp: timestamp,
    );
  }

  /// Empty / placeholder data.
  factory SensorData.empty() {
    return SensorData(
      temperature: 0,
      humidity: 0,
      distance: 0,
      bottlePresent: false,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get temperature classification.
  String get temperatureClass {
    if (temperature >= 35) return 'hot';
    if (temperature >= 30) return 'warm';
    if (temperature >= 20) return 'normal';
    return 'cool';
  }

  /// Get humidity classification.
  String get humidityClass {
    if (humidity >= 70) return 'high';
    if (humidity >= 40) return 'normal';
    return 'low';
  }

  @override
  String toString() =>
      'SensorData(temp: $temperature, humidity: $humidity, distance: $distance, bottle: $bottlePresent)';
}
