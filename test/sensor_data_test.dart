import 'package:flutter_test/flutter_test.dart';
import 'package:smart_coaster_dashboard/models/sensor_data.dart';

void main() {
  group('SensorData', () {
    test('fromMap creates valid SensorData', () {
      final data = SensorData.fromMap({
        'temp': 28.5,
        'humidity': 65.2,
        'distance': 3.1,
        'bottle_present': true,
        'timestamp': 1711555200000,
      });

      expect(data.temperature, 28.5);
      expect(data.humidity, 65.2);
      expect(data.distance, 3.1);
      expect(data.bottlePresent, true);
      expect(data.timestamp, 1711555200000);
    });

    test('temperature classification', () {
      expect(
        SensorData.fromMap({'temp': 36, 'humidity': 0, 'distance': 10}).temperatureClass,
        'hot',
      );
      expect(
        SensorData.fromMap({'temp': 32, 'humidity': 0, 'distance': 10}).temperatureClass,
        'warm',
      );
      expect(
        SensorData.fromMap({'temp': 25, 'humidity': 0, 'distance': 10}).temperatureClass,
        'normal',
      );
      expect(
        SensorData.fromMap({'temp': 15, 'humidity': 0, 'distance': 10}).temperatureClass,
        'cool',
      );
    });

    test('humidity classification', () {
      expect(
        SensorData.fromMap({'temp': 0, 'humidity': 75, 'distance': 10}).humidityClass,
        'high',
      );
      expect(
        SensorData.fromMap({'temp': 0, 'humidity': 50, 'distance': 10}).humidityClass,
        'normal',
      );
      expect(
        SensorData.fromMap({'temp': 0, 'humidity': 30, 'distance': 10}).humidityClass,
        'low',
      );
    });

    test('bottle detection from distance', () {
      // Distance < 5cm → bottle present
      final near = SensorData.fromMap({
        'temp': 25,
        'humidity': 50,
        'distance': 3,
      });
      expect(near.bottlePresent, true);

      // Distance > 5cm → bottle absent
      final far = SensorData.fromMap({
        'temp': 25,
        'humidity': 50,
        'distance': 10,
      });
      expect(far.bottlePresent, false);
    });

    test('empty factory creates zero values', () {
      final empty = SensorData.empty();
      expect(empty.temperature, 0);
      expect(empty.humidity, 0);
      expect(empty.distance, 0);
      expect(empty.bottlePresent, false);
    });
  });
}
