import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSuccess(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(isSuccess: true, title: title, message: message, duration: duration);
  }

  static void showError(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    _show(isSuccess: false, title: title, message: message, duration: duration);
  }

  static void showInfo(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(isSuccess: null, title: title, message: message, duration: duration);
  }

  static void _show({
    required bool? isSuccess,
    required String title,
    required String message,
    required Duration duration,
  }) {
    IconData icon;
    Color backgroundColor;

    if (isSuccess == true) {
      icon = Icons.check_circle_rounded;
      backgroundColor = Colors.green.shade600;
    } else if (isSuccess == false) {
      icon = Icons.error_rounded;
      backgroundColor = Colors.red.shade600;
    } else {
      icon = Icons.info_outline_rounded;
      backgroundColor = Colors.blue.shade600;
    }
  }
}
