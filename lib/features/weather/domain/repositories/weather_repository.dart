import 'package:dartz/dartz.dart';

import 'package:weather_app/core/error/failure.dart';
import '../entities/weather.dart';

abstract class WheatherRepository {
  Future<Either<Failure, Weather>> getWheater(String city);
}
