import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool rounded;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.rounded = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 15, 255, 147),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rounded ? 30 : 0),
          side: const BorderSide(color: Colors.black),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
