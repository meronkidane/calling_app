import 'package:calling_app/src/core/auth/token_storage.dart';
import 'package:calling_app/src/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseUrlProvider = Provider<String>((ref) {
  // Configure via --dart-define or env injection for dev/prod
  const apiBase = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'http://localhost:8080');
  return apiBase;
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage(ref.read(secureStorageProvider));
});

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final dio = ApiClient.createDio(baseUrl);
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(tokenStorageProvider);
  final client = ApiClient(dio, storage);
  client.configureInterceptors(ref);
  return client;
});
