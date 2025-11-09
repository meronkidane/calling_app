import 'package:calling_app/src/core/auth/auth_state.dart';
import 'package:calling_app/src/core/network/api_client.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<String?> requestOtp(String phone) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/auth/request-otp',
      data: {'phone': phone},
    );
    return response.data?['debugOtp'] as String?;
  }

  Future<(AuthTokens, UserProfile)> verifyOtp(String phone, String code) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/auth/verify-otp',
      data: {'phone': phone, 'code': code},
    );
    final tokens =
        AuthTokens.fromJson(response.data!['tokens'] as Map<String, dynamic>);
    final user = UserProfile.fromJson(
        response.data!['user'] as Map<String, dynamic>);
    return (tokens, user);
  }
}
