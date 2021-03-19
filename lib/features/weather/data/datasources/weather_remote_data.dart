import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteData {
  /// Calls the http://api endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<WeatherModel> getWeather(String city);
}
