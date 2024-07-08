import 'package:flutter/material.dart';
import 'package:weather_app/temperature_display.dart';

class DayForecastWeekTabWidget extends StatelessWidget {
  const DayForecastWeekTabWidget({
    super.key,
    required this.time,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherType,
  });
  final String time;
  final int minTemp;
  final int maxTemp;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                time.substring(0, 3),
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Icon(
                getCurrentWeatherIcon(weatherType),
                size: 36,
                color: Colors.white,
              ),
              // TemperatureDisplay(temperature: temp),
              Text(
                minTemp.toString() + '\u00B0C',
                style: TextStyle(color: Colors.blueGrey, fontSize: 24),
              ),
              Text(
                maxTemp.toString() + '\u00B0C',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
          Divider(
            thickness: .5,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
