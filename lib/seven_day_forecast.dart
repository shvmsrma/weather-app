import 'package:flutter/material.dart';
import 'package:weather_app/day_forecast_week_tab.dart';
import 'package:weather_app/models/week_forecast.dart';

class SevenDayForecast extends StatelessWidget {
  final List<WeekForecast> weekWeatherDetails = [
    WeekForecast('Today', -1, 1, 'rainy'),
    WeekForecast('Monday', 2, 10, 'sunny'),
    WeekForecast('Tuesday', 0, 8, 'cloudy'),
    WeekForecast('Wednesday', -3, 5, 'windy'),
    WeekForecast('Thursday', 4, 12, 'rainy'),
    WeekForecast('Friday', 1, 9, 'sunny'),
    WeekForecast('Saturday', 3, 11, 'cloudy'),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 21, 21, 21),
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '7 day forecast',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Divider(
                  color: Colors.white,
                ),
              ],
            ),
            ...weekWeatherDetails.map((dayData) => DayForecastWeekTabWidget(
                time: dayData.label,
                minTemp: dayData.minTemp,
                maxTemp: dayData.maxTemp,
                weatherType: dayData.weatherType)),
          ],
        ),
      ),
    );
  }
}
