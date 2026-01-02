import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

const Map<String, String> monthAbbrevName = {
  'January': 'Jan',
  'February': 'Feb',
  'March': 'Mar',
  'April': 'Apr',
  'May': 'May',
  'June': 'Jun',
  'July': 'Jul',
  'August': 'Aug',
  'September': 'Sep',
  'October': 'Oct',
  'November': 'Nov',
  'December': 'Dec',
};

String? formatDateTime(String? dateTime) {
  if (dateTime == null || dateTime.isEmpty) return null;
  final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
  return formatter.format(DateTime.parse(dateTime));
}

void logUidInfo({
  required String source,
  required String name,
  required String? uid,
  String? parentUid,
  String? layer,
}) {
  if (uid == null || uid.isEmpty) return;

  final layerTag = layer != null ? "[$layer]" : "";
  final parentInfo = parentUid != null ? " | Parent: $parentUid" : "";

  logg.i(
    "🆔 UID_LOG $layerTag: $name\n"
    "   └─ Source: $source\n"
    "   └─ UID: $uid$parentInfo",
  );
}
