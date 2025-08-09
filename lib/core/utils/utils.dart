import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logg = Logger();

extension SizedBoxExtension on num {
  /// Returns a SizedBox with the specified height
  SizedBox get h => SizedBox(height: toDouble());

  /// Returns a SizedBox with the specified width
  SizedBox get w => SizedBox(width: toDouble());
}
