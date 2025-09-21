import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../features/map/utils/map_enums.dart';

final logg = Logger();

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

/// Get the next hierarchical level for drilldown
@Deprecated('Use GeographicLevel.nextLevel instead')
String getNextMapViewLevel(String currentLevel) {
  final level = GeographicLevel.fromString(currentLevel);
  return level.nextLevel?.value ??
      GeographicLevel.upazila.value; // Default fallback
}
