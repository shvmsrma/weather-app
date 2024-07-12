import 'package:flutter/material.dart';

class SearchBarInput extends StatelessWidget {
  SearchBarInput({super.key, required this.onChangeInput});

  final void Function(String value) onChangeInput;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: const Icon(
              Icons.search,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8), // Space between icon and text
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(bottom: 12), // Adjust internal padding
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: 'Search for city',
                labelStyle: TextStyle(color: Colors.white),
                isDense: true, // This reduces the height of the TextField
              ),
              onChanged: (value) {
                onChangeInput(value);
              },
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
