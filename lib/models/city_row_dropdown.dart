import 'package:flutter/material.dart';
import 'package:weather_app/models/city_item.dart';

class CityRow extends StatelessWidget {
  CityRow({super.key, required this.city, required this.onTap});
  final CityItem city;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey), // Add bottom border
          ),
          color: Colors.black, // Background color to blend with the search box
        ),
        padding: EdgeInsets.all(12),
        child: Text(
          city.name + ", " + city.region + ", " + city.country,
          style: TextStyle(color: Colors.white), // Text color
        ),
      ),
    );
  }
}
