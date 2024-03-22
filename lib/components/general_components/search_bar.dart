import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  const MySearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: TextField(
        controller: controller,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.search, size: 25),
          fillColor: Colors.grey[100],
          filled: true,
          hintText: 'Search for \'Pizza\'',
          hintStyle: TextStyle(color: Colors.grey[700]),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
