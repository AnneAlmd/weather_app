import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/error/failure.dart';

import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  WeatherBloc({@required this.getWeather})
      : assert(getWeather != null),
        super(Empty());

  WeatherState get initialState => Empty();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    yield Empty();
    //print('print fetch ');
    if (event is FetchWeather) {
      yield Loading();
      final inputEither = await getWeather(Params(city: event.cityEvent));
      // print('print city EVENT ${event.cityEvent}');
      // print('print city EVENT ${inputEither.toString()}');
      yield inputEither.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (weather) => Loaded(weather: weather),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
