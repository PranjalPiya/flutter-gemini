import 'package:flutter/material.dart';

void showErrorSnackBar({BuildContext? context}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    content: const Text('Write some prompt before submitting!!'),
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context!).showSnackBar(snackBar);
}
