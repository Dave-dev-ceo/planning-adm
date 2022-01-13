import 'package:flutter/material.dart';
import 'package:planning/src/app.dart';

void mostrarAlerta(Widget content, Color color) {
  scaffoldMessegerKey.currentState.showSnackBar(SnackBar(
    content: content,
    // backgroundColor: color,
    elevation: 5.0,
    duration: const Duration(milliseconds: 1500),
    padding: const EdgeInsets.symmetric(
      horizontal: 100.0,
      vertical: 9.0,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ));
}
