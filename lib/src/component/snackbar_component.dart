import 'package:flutter/material.dart';

class SnackbarComponent {
  static showSnackbar(BuildContext context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
