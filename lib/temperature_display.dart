import 'package:flutter/material.dart';

class TemperatureDisplay extends StatelessWidget {
  const TemperatureDisplay(
      {super.key, required this.temperature, this.fontSize = 16});
  final double temperature;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    Color textColor;

    if (temperature < 15) {
      textColor = Color.fromARGB(255, 130, 191, 242);
    } else if (temperature >= 15 && temperature <= 25) {
      textColor = Color.fromARGB(255, 233, 192, 121);
    } else {
      textColor = Color.fromARGB(255, 243, 117, 20);
    }

    return Text(
      '$temperature°C',
      style: TextStyle(color: textColor, fontSize: fontSize),
    );
  }
}
