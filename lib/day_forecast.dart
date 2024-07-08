import 'package:flutter/material.dart';
import 'package:weather_app/forecast_widget.dart';
import 'package:weather_app/models/day_forecast.dart';

class DayForecast extends StatelessWidget {
  final dayForecastDetails = [
    Forecast("Now", 26, 20, 60, 'cloudy'),
    Forecast("15:00", 22, 12, 30, 'rainy'),
    Forecast("16:00", 28, 15, 50, 'windy'),
    Forecast("17:00", 20, 8, 20, 'sunny'),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Forecast for today",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...dayForecastDetails.map((data) => ForecastWidget(
                    time: data.time,
                    temp: data.temp,
                    windSpeed: data.windSpeed,
                    rainChances: data.rainChances,
                    weatherType: data.weatherType,
                  ))
            ],
          ),
        )
      ],
    );
  }
}
