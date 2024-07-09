import 'package:flutter/material.dart';
import 'package:weather_app/location_input.dart';
import 'package:weather_app/search_bar.dart';
import 'package:weather_app/search_bar_with_dropdown.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.onChangeInput});

  final void Function(String value) onChangeInput;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          SearchBarWithDropDown(
            onSelectCity: onChangeInput,
          ),
        ],
      ),
    );
  }
}
