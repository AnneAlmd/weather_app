import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';

void main() {
  MockWeatherRepository repository;
  GetWeather usecase;

  setUp(() {
    repository = MockWeatherRepository();
    usecase = GetWeather(repository);
  });
  final tCity = 'London';
  final tWeather = Weather(city: 'London', temperature: '30', time: '00:00');

  test(
    'should get weather for the city from the repository',
    () async {
      // arrange
      when(repository.getWheater(any)).thenAnswer((_) async => Right(tWeather));
      // act
      final result = await usecase(Params(city: tCity));
      // assert
      expect(result, Right(tWeather));

      verify(repository.getWheater(tCity));
      verifyNoMoreInteractions(repository);
    },
  );
}

class MockWeatherRepository extends Mock implements WheatherRepository {}
