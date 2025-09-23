import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logg = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // No need to show method names
    errorMethodCount: 0, // No need to show error method names
    colors: true, // Use colors in the log output
    printEmojis: true, // Print emojis in the log output
  ),
  level: Level.info, // Set the default log level
  output: ConsoleOutput(), // Use console output for logs
  filter: ProductionFilter(), // Use production filter to avoid debug logs
);

extension SizedBoxExtension on num {
  /// Returns a SizedBox with the specified height
  SizedBox get h => SizedBox(height: toDouble());

  /// Returns a SizedBox with the specified width
  SizedBox get w => SizedBox(width: toDouble());
}

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required Color color,
  bool isLoading = false,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: isLoading
          ? Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(message),
              ],
            )
          : Text(message),
      backgroundColor: color,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    ),
  );
}

extension ExcludeParenthesesStrings on String {
  // if any string is like "example (text)" it will return "example"
  String excludeParentheses() {
    return replaceAll(RegExp(r'\s*\(.*?\)\s*'), '').trim();
  }
}

/// Get the next hierarchical level for drilldown
// @Deprecated('Use GeographicLevel.nextLevel instead')
// String getNextMapViewLevel(String currentLevel) {
//   final level = GeographicLevel.fromString(currentLevel);
//   return level.nextLevel?.value ??
//       GeographicLevel.upazila.value; // Default fallback
// }
