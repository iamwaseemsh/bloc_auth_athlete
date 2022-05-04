import 'package:flutter/material.dart';

class AppServices {
  static showSnackBar(BuildContext context, value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        value,
      ),
    ));
  }
}
