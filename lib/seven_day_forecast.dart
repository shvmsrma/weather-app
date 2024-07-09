import 'package:flutter/material.dart';
import 'package:weather_app/day_forecast_week_tab.dart';
import 'package:weather_app/models/week_forecast.dart';

class SevenDayForecast extends StatelessWidget {
  SevenDayForecast({required this.weekWeatherDetails, super.key});
  List<WeekForecast> weekWeatherDetails = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 21, 21, 21),
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            const Column(
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
