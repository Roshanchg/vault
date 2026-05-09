import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Helper {
  static void showSnackboar(
    BuildContext context,
    String message, {
    Color color = Colors.white,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: color)),
      ),
    );
  }
}
