import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';

import '../../../core/network/connectivity_service.dart';

final epiCenterRepositoryProvider = Provider((ref) {

  return EpiCenterRepository(
    dioClient: ref.watch(dioClientProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

class EpiCenterRepository {
  final Dio _dioClient;
  final ConnectivityService _connectivityService;

  EpiCenterRepository({
    required Dio dioClient,
    required ConnectivityService connectivityService,
  }) : _dioClient = dioClient,
       _connectivityService = connectivityService;
}
