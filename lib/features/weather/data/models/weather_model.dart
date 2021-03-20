import 'package:meta/meta.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  WeatherModel({
    @required String city,
    @required String temperature,
    @required String time,
  }) : super(city: city, temperature: temperature, time: time);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'],
      temperature: json['temp'].toString(),
      time: json['time'],
      //DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temp': int.parse(temperature),
      'time': time,
    };
  }
}
