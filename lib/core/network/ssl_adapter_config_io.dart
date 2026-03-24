import 'package:dio/dio.dart';

import 'staging_ssl_adapter.dart';

void configureStagingSslIfNeeded(Dio dio) {
  StagingSslAdapter.configureForDio(dio);
}

