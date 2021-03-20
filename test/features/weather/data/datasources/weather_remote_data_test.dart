import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  WeatherRemoteData dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = WeatherRemoteDataIpml(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('weather.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getWeather', () {
    final tCity = 'London';
    final url = 'api.hgbrasil.com';
    final path = '/weather';
    final keyCity = {"key": "ab317182", "city_name": tCity};

    test(
      'should perform a GET request on a URL with city being the endpoint and with application/json header',
      () {
        //arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getWeather(tCity);

        // assert
        verify(mockHttpClient.get(
          Uri.http(url, path, keyCity),
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );
    final tWeatherModel =
        WeatherModel.fromJson(json.decode(fixture('weather.json')));

    test(
      'should return Weather when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSource.getWeather(tCity);
        // assert
        expect(result, equals(tWeatherModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getWeather;
        // assert
        expect(() => call(tCity), throwsA(isA<ServerException>()));
      },
    );
  });
}
