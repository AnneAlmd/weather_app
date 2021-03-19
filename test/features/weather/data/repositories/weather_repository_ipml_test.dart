import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/core/platform/network_info.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_data.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_ipml.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

class MockLocalData extends Mock implements WeatherLocalData {}

class MockRemoteData extends Mock implements WeatherRemoteData {}

class MockNetwork extends Mock implements NetworkInfo {}

void main() {
  WeatherRepositoryIpml repository;
  MockLocalData mockLocalData;
  MockRemoteData mockRemoteData;
  MockNetwork mockNetwork;

  setUp(
    () {
      mockLocalData = MockLocalData();
      mockRemoteData = MockRemoteData();
      mockNetwork = MockNetwork();
      repository = WeatherRepositoryIpml(
          remoteData: mockRemoteData,
          localData: mockLocalData,
          network: mockNetwork);
    },
  );

  final tCity = 'London';
  final tWeatherModel =
      WeatherModel(city: 'London', temperature: '30', time: '00:00');
  final Weather tWeather = tWeatherModel;

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetwork.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetwork.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group(
    'getWeather',
    () {
      test(
        'should check if the device is online',
        () async {
          // arrange
          when(mockNetwork.isConnected).thenAnswer((_) async => true);
          // act
          repository.getWheater(tCity);
          // assert
          verify(mockNetwork.isConnected);
        },
      );
    },
  );
  runTestsOnline(() {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteData.getWeather(tCity))
            .thenAnswer((_) async => tWeatherModel);
        // act
        final result = await repository.getWheater(tCity);
        // assert
        verify(mockRemoteData.getWeather(tCity));
        expect(result, equals(Right(tWeather)));
      },
    );

    test(
      'should cache the data locally when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteData.getWeather(tCity))
            .thenAnswer((_) async => tWeatherModel);
        // act
        await repository.getWheater(tCity);
        // assert
        verify(mockRemoteData.getWeather(tCity));
        verify(mockLocalData.cacheWeather(tWeather));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteData.getWeather(tCity)).thenThrow(ServerException());
        // act
        final result = await repository.getWheater(tCity);
        // assert
        verify(mockRemoteData.getWeather(tCity));
        verifyZeroInteractions(mockLocalData);
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });

  runTestsOffline(() {
    test(
      'should return last locally cached data when the cached data is present',
      () async {
        // arrange
        when(mockLocalData.getLastWeather())
            .thenAnswer((_) async => tWeatherModel);
        // act
        final result = await repository.getWheater(tCity);
        // assert
        verifyZeroInteractions(mockRemoteData);
        verify(mockLocalData.getLastWeather());
        expect(result, equals(Right(tWeather)));
      },
    );

    test(
      'should return CacheFailure when there is no cached data present',
      () async {
        // arrange
        when(mockLocalData.getLastWeather()).thenThrow(CacheException());
        // act
        final result = await repository.getWheater(tCity);
        // assert
        verifyZeroInteractions(mockRemoteData);
        verify(mockLocalData.getLastWeather());
        expect(result, equals(Left(CacheFailure())));
      },
    );
  });
}
