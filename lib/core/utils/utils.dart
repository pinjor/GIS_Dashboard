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

enum MapLevel {
  district('districts'),
  upazilla('upazilas'),
  union('union'),
  ward('ward'),
  subblock('subblock');

  final String value;
  const MapLevel(this.value);
}

enum AreaType {
  district('district'),
  citycorporation('city_corporation');

  final String value;
  const AreaType(this.value);
}
