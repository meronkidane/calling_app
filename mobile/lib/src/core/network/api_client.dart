import 'dart:async';

import 'package:calling_app/src/core/auth/auth_state.dart';
import 'package:calling_app/src/core/auth/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _log = Logger('ApiClient');

class ApiClient {
  ApiClient(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  static Dio createDio(String baseUrl) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ));
    return dio;
  }

  void configureInterceptors(Ref ref) {
    _dio.interceptors.clear();
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final (access, _) = await _tokenStorage.readTokens();
        if (access != null) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final resolved = await _handleRefresh(ref, error.requestOptions);
          if (resolved != null) {
            handler.resolve(resolved);
            return;
          }
        }
        handler.next(error);
      },
    ));
  }

  Future<Response<dynamic>?> _handleRefresh(
      Ref ref, RequestOptions failedRequest) async {
    try {
      final (access, refresh) = await _tokenStorage.readTokens();
      if (refresh == null) {
        return null;
      }
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refresh},
        options: Options(headers: {'Authorization': null}),
      );

      final tokens = AuthTokens.fromJson(response.data!);
      await _tokenStorage.persistTokens(
          tokens.accessToken, tokens.refreshToken);

      final cloned = await _dio.fetch<dynamic>(failedRequest
          ..headers['Authorization'] = 'Bearer ${tokens.accessToken}');
      return cloned;
    } catch (err, stack) {
      _log.warning('Refresh token flow failed', err, stack);
      await _tokenStorage.clear();
      return null;
    }
  }

  Dio get dio => _dio;
}
