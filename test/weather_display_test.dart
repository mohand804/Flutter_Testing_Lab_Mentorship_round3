import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Weather Display - Temperature Conversions', () {
    test('Celsius to Fahrenheit conversion - freezing point', () {
      final result = TemperatureConverter.celsiusToFahrenheit(0);
      expect(result, 32.0);
    });

    test('Celsius to Fahrenheit conversion - boiling point', () {
      final result = TemperatureConverter.celsiusToFahrenheit(100);
      expect(result, 212.0);
    });

    test('Celsius to Fahrenheit conversion - negative temperature', () {
      final result = TemperatureConverter.celsiusToFahrenheit(-40);
      expect(result, -40.0);
    });

    test('Celsius to Fahrenheit conversion - room temperature', () {
      final result = TemperatureConverter.celsiusToFahrenheit(22.5);
      expect(result, closeTo(72.5, 0.01));
    });

    test('Fahrenheit to Celsius conversion - freezing point', () {
      final result = TemperatureConverter.fahrenheitToCelsius(32);
      expect(result, 0.0);
    });

    test('Fahrenheit to Celsius conversion - boiling point', () {
      final result = TemperatureConverter.fahrenheitToCelsius(212);
      expect(result, closeTo(100.0, 0.01));
    });

    test('Fahrenheit to Celsius conversion - negative temperature', () {
      final result = TemperatureConverter.fahrenheitToCelsius(-40);
      expect(result, -40.0);
    });

    test('Fahrenheit to Celsius conversion - room temperature', () {
      final result = TemperatureConverter.fahrenheitToCelsius(72.5);
      expect(result, closeTo(22.5, 0.01));
    });

    test('Round trip conversion maintains value', () {
      const original = 25.0;
      final toF = TemperatureConverter.celsiusToFahrenheit(original);
      final backToC = TemperatureConverter.fahrenheitToCelsius(toF);
      expect(backToC, closeTo(original, 0.01));
    });
  });

  group('Weather Display - Data Processing', () {
    test('WeatherData.fromJson - complete valid data', () {
      final json = {
        'city': 'New York',
        'temperature': 22.5,
        'description': 'Sunny',
        'humidity': 65,
        'windSpeed': 12.3,
        'icon': '☀️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, 'New York');
      expect(weatherData.temperatureCelsius, 22.5);
      expect(weatherData.description, 'Sunny');
      expect(weatherData.humidity, 65);
      expect(weatherData.windSpeed, 12.3);
      expect(weatherData.icon, '☀️');
    });

    test('WeatherData.fromJson - integer temperature converted to double', () {
      final json = {
        'city': 'Tokyo',
        'temperature': 25,
        'description': 'Cloudy',
        'humidity': 70,
        'windSpeed': 5,
        'icon': '☁️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.temperatureCelsius, 25.0);
      expect(weatherData.temperatureCelsius, isA<double>());
      expect(weatherData.windSpeed, 5.0);
      expect(weatherData.windSpeed, isA<double>());
    });

    test('WeatherData.fromJson - missing description uses default', () {
      final json = {
        'city': 'London',
        'temperature': 15.0,
        'humidity': 85,
        'windSpeed': 8.5,
        'icon': '🌧️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, 'London');
      expect(weatherData.description, 'No description');
      expect(weatherData.humidity, 85);
    });

    test('WeatherData.fromJson - missing humidity uses default', () {
      final json = {
        'city': 'Paris',
        'temperature': 18.0,
        'description': 'Partly cloudy',
        'windSpeed': 7.0,
        'icon': '⛅',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.humidity, 0);
      expect(weatherData.city, 'Paris');
    });

    test('WeatherData.fromJson - missing windSpeed uses default', () {
      final json = {
        'city': 'Berlin',
        'temperature': 20.0,
        'description': 'Clear',
        'humidity': 60,
        'icon': '☀️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.windSpeed, 0.0);
      expect(weatherData.city, 'Berlin');
    });

    test('WeatherData.fromJson - missing icon uses default', () {
      final json = {
        'city': 'Rome',
        'temperature': 28.0,
        'description': 'Hot',
        'humidity': 45,
        'windSpeed': 3.5,
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.icon, '🌡️');
      expect(weatherData.city, 'Rome');
    });

    test('WeatherData.fromJson - all optional fields missing use defaults', () {
      final json = {'city': 'Sydney', 'temperature': 22.0};

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, 'Sydney');
      expect(weatherData.temperatureCelsius, 22.0);
      expect(weatherData.description, 'No description');
      expect(weatherData.humidity, 0);
      expect(weatherData.windSpeed, 0.0);
      expect(weatherData.icon, '🌡️');
    });

    test('WeatherData.fromJson - throws FormatException when city missing', () {
      final json = {'temperature': 22.5, 'description': 'Sunny'};

      expect(() => WeatherData.fromJson(json), throwsA(isA<FormatException>()));
    });

    test(
      'WeatherData.fromJson - throws FormatException when temperature missing',
      () {
        final json = {'city': 'New York', 'description': 'Sunny'};

        expect(
          () => WeatherData.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'WeatherData.fromJson - throws FormatException with correct message',
      () {
        final json = {'description': 'Sunny'};

        expect(
          () => WeatherData.fromJson(json),
          throwsA(
            predicate(
              (e) =>
                  e is FormatException &&
                  e.message == 'Missing required fields: city and temperature',
            ),
          ),
        );
      },
    );

    test('WeatherData.fromJson - handles negative temperature', () {
      final json = {
        'city': 'Moscow',
        'temperature': -15.5,
        'description': 'Snowy',
        'humidity': 90,
        'windSpeed': 10.0,
        'icon': '❄️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.temperatureCelsius, -15.5);
      expect(weatherData.city, 'Moscow');
    });

    test('WeatherData.fromJson - handles zero values', () {
      final json = {
        'city': 'Test City',
        'temperature': 0.0,
        'humidity': 0,
        'windSpeed': 0.0,
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.temperatureCelsius, 0.0);
      expect(weatherData.humidity, 0);
      expect(weatherData.windSpeed, 0.0);
    });

    test('WeatherData.fromJson - handles very high temperature', () {
      final json = {
        'city': 'Death Valley',
        'temperature': 56.7,
        'description': 'Extremely hot',
        'humidity': 10,
        'windSpeed': 2.0,
        'icon': '🔥',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.temperatureCelsius, 56.7);
      expect(weatherData.description, 'Extremely hot');
    });
  });
}
