import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';

class MockGetWeather extends Mock implements GetWeather {}

void main() {
  WeatherBloc bloc;
  MockGetWeather mockGetWeather;

  setUp(() {
    mockGetWeather = MockGetWeather();
    bloc = WeatherBloc(getWeather: mockGetWeather);
  });
  test('initialState should be empty', () {
    //assert
    expect(bloc.initialState, equals(Empty()));
  });
  group('FetchGetWeather', () {
    final String tCity = 'London';
    final Weather tWeather =
        Weather(city: 'London', temperature: '30', time: '00:00');
    test(
      'should get weather for the city',
      () async {
        //arrange
        when(mockGetWeather(any)).thenAnswer((_) async => Right(tWeather));
        //act
        bloc.add(FetchWeather(tCity));
        await untilCalled(mockGetWeather(any));
        //assert
        verify(mockGetWeather(Params(city: tCity)));
      },
    );

    test(
      'should emit [loading, loaded] when data is gotten successfully',
      () async {
        //arrange
        when(mockGetWeather(any)).thenAnswer((_) async => Right(tWeather));
        //assert later
        final expected = [
          bloc.initialState,
          Loading(),
          Loaded(weather: tWeather),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(FetchWeather(tCity));
      },
    );

    test(
      'should emit [loading, Error] when data is gotten Unsuccessfully',
      () async {
        //arrange
        when(mockGetWeather(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert later
        final expected = [
          bloc.initialState,
          Loading(),
          Error(message: 'Server Failure'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        //act
        bloc.add(FetchWeather(tCity));
      },
    );
  });
}
