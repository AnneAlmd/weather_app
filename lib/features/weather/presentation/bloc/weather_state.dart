part of 'weather_bloc.dart';

@immutable
abstract class WeatherState extends Equatable {
  WeatherState([List props = const <dynamic>[]]) : super();
}

//empty state
class Empty extends WeatherState {
  @override
  List<Object> get props => [];
}

class Loading extends WeatherState {
  @override
  List<Object> get props => [];
}

class Loaded extends WeatherState {
  final Weather weather;

  Loaded({@required this.weather});

  @override
  List<Object> get props => [weather];
}

class Error extends WeatherState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
