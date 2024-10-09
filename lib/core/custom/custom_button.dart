import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final void Function()? onPressed;
  const CustomButton({super.key, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text('$title'));
  }
}
