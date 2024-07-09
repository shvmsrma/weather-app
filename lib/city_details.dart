import 'package:flutter/material.dart';

class CityDetails extends StatelessWidget {
  const CityDetails(
      {super.key,
      required this.city,
      required this.dayType,
      required this.temp,
      required this.forecastType,
      required this.minTemp,
      required this.maxTemp});
  final String city;
  final String dayType;
  final int temp;
  final String forecastType;
  final int minTemp;
  final int maxTemp;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          city,
          style: TextStyle(fontSize: 36, color: Colors.white),
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          "Today",
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          decoration: const BoxDecoration(
              border: BorderDirectional(
                  bottom:
                      BorderSide(color: Color.fromARGB(255, 136, 135, 135)))),
          child: Text(
            "$temp \u00B0C",
            style: const TextStyle(
                fontSize: 48, color: Color.fromARGB(255, 69, 160, 235)),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          forecastType,
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          "$minTemp \u00B0C/$maxTemp \u00B0C",
          style: const TextStyle(color: Colors.blue, fontSize: 24),
        )
      ],
    );
  }
}
