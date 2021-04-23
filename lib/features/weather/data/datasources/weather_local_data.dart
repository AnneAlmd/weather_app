import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherLocalData {
  // Gets the cached [WeatherModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<WeatherModel> getLastWeather();

  Future<void> cacheWeather(WeatherModel weatherToCache);
}

const CACHED_WEATHER = 'CACHED_WEATHER';

class WeatherLocalDataIpml implements WeatherLocalData {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataIpml(this.sharedPreferences);

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache) {
    return sharedPreferences.setString(
      CACHED_WEATHER,
      json.encode(weatherToCache.toJson()),
    );
  }

  @override
  Future<WeatherModel> getLastWeather() {
    final jsonString = sharedPreferences.getString(CACHED_WEATHER);
    // Future which is immediately completed
    if (jsonString != null) {
      return Future.value(WeatherModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
