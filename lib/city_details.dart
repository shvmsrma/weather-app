import 'package:flutter/material.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/temperature_display.dart';

class CityDetails extends StatelessWidget {
  const CityDetails({super.key, required this.cityDetails});
  final CurrentCity cityDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          cityDetails.name,
          style: TextStyle(fontSize: 48, color: Colors.white),
        ),
        const Text(
          "Today",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
            decoration: const BoxDecoration(
                border: BorderDirectional(
                    bottom:
                        BorderSide(color: Color.fromARGB(255, 136, 135, 135)))),
            child: TemperatureDisplay(
              temperature: cityDetails.currentTemp.toDouble(),
              fontSize: 64,
            )),
        const SizedBox(
          height: 12,
        ),
        Text(
          cityDetails.forecastType,
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TemperatureDisplay(
              temperature: cityDetails.minTemp.toDouble(),
              fontSize: 24,
            ),
            const Text(
              "/",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            TemperatureDisplay(
              temperature: cityDetails.maxTemp.toDouble(),
              fontSize: 24,
            ),
          ],
        ),
      ],
    );
  }
}
