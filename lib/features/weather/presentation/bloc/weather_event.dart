part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  WeatherEvent([List props = const <dynamic>[]]) : super();
}

class FetchWeather extends WeatherEvent {
  final String cityEvent;

  FetchWeather(this.cityEvent) : super([cityEvent]);

  @override
  List<Object> get props => [cityEvent];
}
