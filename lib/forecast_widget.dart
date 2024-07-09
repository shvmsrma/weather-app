import 'package:flutter/material.dart';
import 'package:weather_app/temperature_display.dart';

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
  IconData getCurrentWeatherIcon(weatherType) {
    String condition = weatherType.toLowerCase();
    if (condition.contains('rain') || condition.contains('drizzle')) {
      return Icons.water_drop_sharp;
    } else if (condition.contains('snow') || condition.contains('sleet')) {
      return Icons.snowing;
    } else if (condition.contains('thunder') ||
        condition.contains('lightning')) {
      return Icons.thunderstorm;
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return Icons.cloud;
    } else if (condition.contains('fog') || condition.contains('mist')) {
      return Icons.cloud;
    } else if (condition.contains('wind') || condition.contains('gust')) {
      return Icons.wind_power;
    } else if (condition.contains('sun') || condition.contains('clear')) {
      return Icons.wb_sunny;
    } else {
      return Icons.wb_sunny;
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
        Icon(
          getCurrentWeatherIcon(weatherType),
          size: 36,
          color: Colors.white,
        ),
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
