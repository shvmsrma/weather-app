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
  final int temp;
  final int windSpeed;
  final int rainChances;
  final String weatherType;
  IconData getCurrentWeatherIcon(weatherType) {
    switch (weatherType) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'windy':
        return Icons.wind_power;
      case 'rainy':
        return Icons.water_drop_sharp;
    }
    return Icons.wb_sunny;
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
        Icon(
          Icons.wind_power,
          size: 36,
          color: Colors.grey,
        ),
        SizedBox(height: 4),
        Text(
          windSpeed.toString() + ' km/h',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
        SizedBox(height: 12),
        Icon(
          Icons.umbrella_outlined,
          size: 36,
          color: Colors.blue,
        ),
        Text(
          rainChances.toString() + '%',
          style: TextStyle(color: Colors.blue, fontSize: 24),
        )
      ],
    );
  }
}
