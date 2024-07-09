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
          const Icon(
            Icons.search,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search your favorite location',
                labelStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                isDense: true, // This reduces the height of the TextField
                contentPadding: EdgeInsets.symmetric(
                    vertical: 8), // Adjust vertical padding
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
