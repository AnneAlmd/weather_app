import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherLocalData {
  // Gets the cached [WeatherModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<WeatherModel> getLastWeather();

  Future<void> cacheWeather(WeatherModel weatherToCache);
}
