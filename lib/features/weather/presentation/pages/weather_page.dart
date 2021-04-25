import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/constants/space.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/injection_container.dart';

class WeatherPage extends StatelessWidget {
  Widget _stateReturn(WeatherState state) {
    if (state is Empty) {
      return MessageDisplay(message: 'Start Searching!');
    } else if (state is Loaded) {
      return MessageDisplay(message: state.weather.city);
    } else if (state is Error) {
      return MessageDisplay(message: state.message);
    } else {
      return MessageDisplay(message: 'Start Loading!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<WeatherBloc> buildBody(context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (_) => sl<WeatherBloc>(),
        child: Center(
          child: Container(
            height: double.infinity,
            width: screenWidth * 0.8,
            child: Column(
              children: [
                vSpace40,
                BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                  return _stateReturn(state);
                }),
                vSpace20,
                Placeholder(
                  fallbackHeight: 30,
                  color: Colors.green,
                ),
                vSpace40,
                Placeholder(
                  fallbackHeight: 50,
                  color: Colors.blue,
                ),
                vSpace20,
                Row(
                  children: [
                    Expanded(
                      child: Placeholder(
                        fallbackHeight: 30,
                      ),
                    ),
                    hSpace10,
                    Expanded(
                      child: Placeholder(
                        fallbackHeight: 30,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Text(
        message,
        style: TextStyle(fontSize: 35),
        textAlign: TextAlign.center,
      ),
    );
  }
}
