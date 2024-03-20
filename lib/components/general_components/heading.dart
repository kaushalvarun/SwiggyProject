import 'package:flutter/material.dart';

class MyHeading extends StatelessWidget {
  final String text;
  const MyHeading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
