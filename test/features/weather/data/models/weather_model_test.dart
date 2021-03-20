import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tWeatherModel =
      WeatherModel(city: 'London', temperature: '30', time: '00:00');

  test(
    'Should be a subclass of Weather entity',
    () async {
      //assert
      expect(tWeatherModel, isA<Weather>());
    },
  );
  group('fromJson', () {
    test(
      'Should return a valid model when the JSON city is an string',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('weather.json'));
        // act
        final result = WeatherModel.fromJson(jsonMap);
        //assert
        expect(result, tWeatherModel);
      },
    );
  });
  group(
    'toJson',
    () {
      test(
        'Should return a JSON map containing the proper data',
        () async {
          //act
          final result = tWeatherModel.toJson();

          //assert
          final expectMap = {"city": "London", "temp": 30, "time": "00:00"};

          expect(result, expectMap);
        },
      );
    },
  );
}
