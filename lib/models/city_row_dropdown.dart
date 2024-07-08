import 'package:flutter/material.dart';

class CityRow extends StatelessWidget {
  CityRow(
      {super.key,
      required this.city,
      required this.state,
      required this.country,
      required this.data,
      required this.onTap});
  final String city;
  final String state;
  final String country;
  final Map data;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Text(
            city + "," + state + "," + country,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
