import 'package:flutter/material.dart';
import 'package:weather_app/widgets/location_input.dart';
import 'package:weather_app/models/city_item.dart';
import 'package:weather_app/widgets/search_bar.dart';
import 'package:weather_app/widgets/search_bar_with_dropdown.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.onChangeInput});

  final Function(CityItem value) onChangeInput;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        children: [
          CitySearch(
            onSelectCity: (CityItem city) {
              onChangeInput(city);
            },
          ),
        ],
      ),
    );
  }
}
