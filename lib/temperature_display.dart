import 'package:flutter/material.dart';

class TemperatureDisplay extends StatelessWidget {
  TemperatureDisplay(
      {super.key, required this.temperature, this.fontSize = 16});
  final int temperature;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    Color textColor;

    if (temperature < 15) {
      textColor = Colors.blue;
    } else if (temperature >= 15 && temperature <= 25) {
      textColor = Colors.orange;
    } else {
      textColor = Colors.red;
    }

    return Text(
      '$temperature°C',
      style: TextStyle(color: textColor, fontSize: fontSize),
    );
  }
}
