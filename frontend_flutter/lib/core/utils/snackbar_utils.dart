import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      Icons.check_circle_outline,
      Colors.green.shade600,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      Icons.error_outline,
      Theme.of(context).colorScheme.error,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      Icons.info_outline,
      Theme.of(context).colorScheme.primary,
    );
  }

  static void _showSnackbar(BuildContext context, String message, IconData icon, Color color) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
