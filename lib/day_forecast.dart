import 'package:flutter/material.dart';
import 'package:weather_app/forecast_widget.dart';
import 'package:weather_app/models/day_forecast.dart';

class DayForecast extends StatelessWidget {
  DayForecast({required this.forecastDetails});
  List<Forecast> forecastDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Forecast for today",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...forecastDetails.map((data) => ForecastWidget(
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
