import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/pages/weather_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Anne',
      theme: ThemeData(
        primaryColor: Colors.pink[800],
        accentColor: Colors.cyan[400],
      ),
      home: WeatherPage(),
    );
  }
}
