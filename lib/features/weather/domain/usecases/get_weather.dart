import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetWeather extends UseCase<Weather, Params> {
  final WheatherRepository repository;

  GetWeather(@required this.repository);

  @override
  Future<Either<Failure, Weather>> call(Params params) async {
    return await repository.getWheater(params.city);
  }
}

class Params extends Equatable {
  final String city;

  Params({@required this.city});

  @override
  List<Object> get props => [city];
}
