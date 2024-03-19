import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String msg;
  final Color buttonColor;
  final Color textColor;
  final Function()? onTap;
  const MyButton({
    super.key,
    required this.onTap,
    required this.msg,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(msg,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          )),
    );
  }
}
