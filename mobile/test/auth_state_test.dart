import 'package:calling_app/src/core/auth/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthState copyWith toggles authentication flag', () {
    const state = AuthState();
    final authenticated = state.copyWith(
      isAuthenticated: true,
      tokens: const AuthTokens(accessToken: 'a', refreshToken: 'b'),
    );

    expect(authenticated.isAuthenticated, isTrue);
    expect(authenticated.tokens?.accessToken, 'a');
  });
}
