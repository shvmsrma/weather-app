import 'package:flutter/material.dart';

class ActionContainer extends StatelessWidget {
  ActionContainer({super.key, required this.isFavorite, required this.onTap});
  final bool isFavorite;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.favorite,
            size: 24,
            color: isFavorite ? Colors.red : Colors.white,
          ),
        ],
      ),
    );
  }
}
