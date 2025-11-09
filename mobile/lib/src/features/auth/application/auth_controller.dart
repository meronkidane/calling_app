import 'package:calling_app/src/core/auth/auth_state.dart';
import 'package:calling_app/src/core/auth/token_storage.dart';
import 'package:calling_app/src/core/providers.dart';
import 'package:calling_app/src/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final apiClient = ref.watch(apiClientProvider);
  final repository = AuthRepository(apiClient);
  final controller = AuthController(repository, tokenStorage);
  controller.restore();
  return controller;
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository, this._tokenStorage)
      : super(const AuthState());

  final AuthRepository _repository;
  final TokenStorage _tokenStorage;

  Future<void> restore() async {
    final (access, refresh) = await _tokenStorage.readTokens();
    if (access != null && refresh != null) {
      state = state.copyWith(
        isAuthenticated: true,
        tokens: AuthTokens(accessToken: access, refreshToken: refresh),
      );
    }
  }

  Future<String?> requestOtp(String phone) async {
    state = state.copyWith(isLoading: true);
    try {
      final debugOtp = await _repository.requestOtp(phone);
      return debugOtp;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> verifyOtp(String phone, String code) async {
    state = state.copyWith(isLoading: true);
    try {
      final (tokens, user) = await _repository.verifyOtp(phone, code);
      await _tokenStorage.persistTokens(
        tokens.accessToken,
        tokens.refreshToken,
      );
      state = state.copyWith(
        isAuthenticated: true,
        tokens: tokens,
        user: user,
        isLoading: false,
      );
    } catch (err) {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _tokenStorage.clear();
    state = const AuthState();
  }
}
