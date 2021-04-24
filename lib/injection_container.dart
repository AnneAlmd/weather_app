import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/platform/network_info.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_data.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_ipml.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:http/http.dart' as http;

// service locator
final sl = GetIt.instance;

void init() async {
  // Features - weather
  //* *  1 BLoC has streams to been closed
  sl.registerFactory(() => WeatherBloc(getWeather: sl()));
  //* * 2 Use Cases
  sl.registerLazySingleton(() => GetWeather(sl()));
  //* * 3 Repository
  sl.registerLazySingleton<WheatherRepository>(() =>
      WeatherRepositoryIpml(remoteData: sl(), localData: sl(), network: sl()));
  //* * 4 Data Sources
  sl.registerLazySingleton<WeatherRemoteData>(
      () => WeatherRemoteDataIpml(client: sl()));
  sl.registerLazySingleton<WeatherLocalData>(() => WeatherLocalDataIpml(sl()));

  // Core
  //* * 5 Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // External
  //* * 6 sharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client);
  sl.registerLazySingleton(() => DataConnectionChecker());
}
