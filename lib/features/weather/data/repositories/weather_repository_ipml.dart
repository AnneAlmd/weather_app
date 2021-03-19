import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/core/platform/network_info.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_data.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryIpml extends WheatherRepository {
  final WeatherRemoteData remoteData;
  final WeatherLocalData localData;
  final NetworkInfo network;

  WeatherRepositoryIpml(
      {@required this.remoteData,
      @required this.localData,
      @required this.network});

  @override
  Future<Either<Failure, Weather>> getWheater(String city) async {
    if (await network.isConnected) {
      try {
        final remoteWeather = await remoteData.getWeather(city);
        localData.cacheWeather(remoteWeather);
        return Right(remoteWeather);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localWeather = await localData.getLastWeather();
        return Right(localWeather);
      } on CacheException {
        return Left(CacheFailure());
      }
    }

    //return Right(await remoteData.getWeather(city));
    //throw UnimplementedError();
  }
}
