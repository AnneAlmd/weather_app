import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_data.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  WeatherLocalDataIpml dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = WeatherLocalDataIpml(mockSharedPreferences);
  });
  group(
    'getWeather',
    () {
      final tWeatherModel =
          WeatherModel.fromJson(json.decode(fixture('weather_cached.json')));

      test(
        'should return Weather from SharedPreferences when there is one in the cache',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture('weather_cached.json'));
          // act
          final result = await dataSource.getLastWeather();
          // assert
          verify(mockSharedPreferences.getString(CACHED_WEATHER));
          expect(result, equals(tWeatherModel));
        },
      );

      test('should throw a CacheException when there is not a cached value',
          () {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        // Not calling the method here, just storing it inside a call variable
        final call = dataSource.getLastWeather;
        // assert
        expect(() => call(), throwsA(isA<CacheException>()));
      });
    },
  );
  group('cacheWeather', () {
    final tWeatherModel =
        WeatherModel(city: 'London', temperature: '30', time: '00:00');

    test('should call SharedPreferences to cache the data', () {
      // act
      dataSource.cacheWeather(tWeatherModel);
      // assert
      final expectedJsonString = json.encode(tWeatherModel.toJson());
      verify(mockSharedPreferences.setString(
        CACHED_WEATHER,
        expectedJsonString,
      ));
    });
  });
}
