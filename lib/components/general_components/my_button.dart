import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function() onPressed;
  final String msg;
  final Color buttonColor;
  final Color textColor;
  final double? width;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.msg,
    required this.buttonColor,
    required this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 20)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
        ),
        child: Text(
          msg,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
