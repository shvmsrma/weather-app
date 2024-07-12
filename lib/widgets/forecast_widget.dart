import 'package:flutter/material.dart';
import 'package:weather_app/widgets/temperature_display.dart';

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({
    super.key,
    required this.time,
    required this.temp,
    required this.windSpeed,
    required this.rainChances,
    required this.weatherType,
  });
  final String time;
  final double temp;
  final double windSpeed;
  final double rainChances;
  final String weatherType;
  Widget getCurrentWeatherWidget(weatherType) {
    String condition = weatherType.toLowerCase();
    if (condition.contains('rain') || condition.contains('drizzle')) {
      return const Icon(
        Icons.water_drop_sharp,
        size: 36,
        color: Color.fromARGB(255, 84, 170, 217),
      );
    } else if (condition.contains('snow') || condition.contains('sleet')) {
      return const Icon(
        Icons.snowing,
        size: 36,
        color: Color.fromARGB(255, 221, 220, 220),
      );
    } else if (condition.contains('thunder') ||
        condition.contains('lightning')) {
      return const Icon(
        Icons.thunderstorm,
        size: 36,
        color: Color.fromARGB(255, 147, 146, 146),
      );
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return const Icon(
        Icons.cloud,
        size: 36,
        color: Colors.white,
      );
    } else if (condition.contains('fog') || condition.contains('mist')) {
      return const Icon(
        Icons.cloud,
        size: 36,
        color: Colors.white,
      );
    } else if (condition.contains('wind') || condition.contains('gust')) {
      return const Icon(
        Icons.wind_power,
        size: 36,
        color: Colors.white,
      );
    } else if (condition.contains('sun') || condition.contains('clear')) {
      return const Icon(
        Icons.wb_sunny,
        size: 36,
        color: Color.fromARGB(255, 237, 232, 69),
      );
    } else {
      return const Icon(
        Icons.wb_sunny,
        size: 36,
        color: Color.fromARGB(255, 237, 232, 69),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          time,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 4),
        getCurrentWeatherWidget(weatherType),
        SizedBox(height: 4),
        TemperatureDisplay(temperature: temp),
        SizedBox(height: 12),
        const Icon(
          Icons.wind_power,
          size: 36,
          color: Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          '$windSpeed km/h',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
        const SizedBox(height: 12),
        const Icon(
          Icons.umbrella_outlined,
          size: 36,
          color: Colors.blue,
        ),
        Text(
          '$rainChances%',
          style: const TextStyle(color: Colors.blue, fontSize: 24),
        )
      ],
    );
  }
}
