import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/network/dio_client_provider.dart';

final summaryRepositoryProvider = Provider(
  (ref) => SummaryRepository(dioClient: ref.watch(dioClientProvider)),
);

class SummaryRepository {
  final Dio _dioClient;

  SummaryRepository({required Dio dioClient}) : _dioClient = dioClient;
}
