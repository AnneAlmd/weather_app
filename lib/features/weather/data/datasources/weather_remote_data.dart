import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:weather_app/core/error/exceptions.dart';

import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteData {
  /// Calls the http://api endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<WeatherModel> getWeather(String city);
}

class WeatherRemoteDataIpml implements WeatherRemoteData {
  final http.Client client;

  WeatherRemoteDataIpml({@required this.client});

  @override
  Future<WeatherModel> getWeather(String city) => _getWeatherFromUrl(
      'api.hgbrasil.com', '/weather', {"key": "ab317182", "city_name": city});

  Future<WeatherModel> _getWeatherFromUrl(
      String url, String path, Map<String, dynamic> keyCity) async {
    final response = await client.get(
      Uri.http(url, path, keyCity),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      print(apiResponse);
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
