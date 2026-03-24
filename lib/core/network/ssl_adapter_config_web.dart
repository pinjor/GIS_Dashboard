import 'package:dio/dio.dart';

void configureStagingSslIfNeeded(Dio dio) {
  // Web uses browser networking stack; do not apply IO SSL adapter here.
}

