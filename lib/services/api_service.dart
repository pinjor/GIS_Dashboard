import 'dart:convert';
import 'dart:developer';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/utils/utils.dart';

class ApiService {
  final Dio _dio = Dio();
  // create a singleton instance
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<void> fetchGeoJson() async {
    final uri = 'http://46.250.234.81/storage/build-json/shapes/shape.json.gz';

    try {
      logg.i("Fetching GeoJSON from $uri");
      final response = await _dio.get(
        uri,
        options: Options(
          responseType: ResponseType.bytes, // Get raw bytes
        ),
      );
      log('...response received...');
      logg.i('Response received: $response');
      final bytes = response.data as List<int>;
      final archive = GZipDecoder().decodeBytes(bytes);
      logg.i('Decompressed Archive: $archive');
      logg.i('Decompressed Archive decoded: ${utf8.decode(archive)}');
      final jsonString = String.fromCharCodes(archive);
      logg.i('jsonString:::: $jsonString');

      // // Check if server sent gzip-compressed content
      // if (response.headers.map['content-encoding']?.contains('gzip') ?? false) {
      //   // Decompress GZIP
      //   final decompressed = GZipCodec().decode(response.data!);
      //   final jsonString = utf8.decode(decompressed);
      //   final jsonData = json.decode(jsonString);

      //   debugPrint(jsonData);
      // } else {
      //   // Not compressed
      //   final jsonString = utf8.decode(response.data!);
      //   final jsonData = json.decode(jsonString);

      //   debugPrint('Not compressed: $jsonData');
      // }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Add more methods for POST, PUT, DELETE if needed
}
