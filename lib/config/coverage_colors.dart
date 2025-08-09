import 'package:flutter/material.dart';

class CoverageColors {
  static const Color notDefine = Color(0xFFF2F4F6);    // No data
  static const Color veryLow = Color(0xFFFF4C4C);      // <80%
  static const Color low = Color(0xFFF7931E);          // 80-85%
  static const Color medium = Color(0xFFEDED9D);       // 85-90%
  static const Color high = Color(0xFFA6D96A);         // 90-95%
  static const Color veryHigh = Color(0xFF2CA25F);     // >95%
  
  static Color getCoverageColor(double? coverage) {
    if (coverage == null || coverage == 0) return notDefine;
    if (coverage < 80) return veryLow;
    if (coverage < 85) return low;
    if (coverage < 90) return medium;
    if (coverage < 95) return high;
    return veryHigh;
  }
}