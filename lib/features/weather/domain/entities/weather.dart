import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Weather extends Equatable {
  final String city;
  final String temperature;
  final String time;
  Weather({
    @required this.city,
    @required this.temperature,
    @required this.time,
  });

  @override
  List<Object> get props => [city, temperature, time];
}
