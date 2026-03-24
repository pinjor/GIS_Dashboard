import 'package:dio/dio.dart';

import 'ssl_adapter_config_stub.dart'
    if (dart.library.io) 'ssl_adapter_config_io.dart'
    if (dart.library.js_interop) 'ssl_adapter_config_web.dart' as impl;

void configureStagingSslIfNeeded(Dio dio) {
  impl.configureStagingSslIfNeeded(dio);
}

