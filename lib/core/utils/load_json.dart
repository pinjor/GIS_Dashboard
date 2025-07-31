import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadJson(String path) async {
  String jsonString = await rootBundle.loadString(path);
  log('Given JSON file Path $path');
  log('JSON content: $jsonString');
  final json = jsonDecode(jsonString);
  log('Parsed JSON: $json');
  return json;
}