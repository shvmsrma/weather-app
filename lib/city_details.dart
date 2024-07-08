import 'package:flutter/material.dart';

class CityDetails extends StatelessWidget {
  CityDetails(
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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            city,
            style: TextStyle(fontSize: 36, color: Colors.white),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            dayType,
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom:
                        BorderSide(color: Color.fromARGB(255, 136, 135, 135)))),
            child: Text(
              temp.toString() + " \u00B0" + "C",
              style: TextStyle(
                  fontSize: 48, color: const Color.fromARGB(255, 69, 160, 235)),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            forecastType,
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            minTemp.toString() + "/" + maxTemp.toString(),
            style: TextStyle(color: Colors.blue, fontSize: 24),
          )
        ],
      ),
    );
  }
}
