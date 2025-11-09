import 'package:calling_app/src/features/auth/application/auth_controller.dart';
import 'package:calling_app/src/features/auth/presentation/login_screen.dart';
import 'package:calling_app/src/features/auth/presentation/verify_screen.dart';
import 'package:calling_app/src/features/home/presentation/home_shell.dart';
import 'package:calling_app/src/features/home/presentation/history_screen.dart';
import 'package:calling_app/src/features/calls/presentation/dialer_screen.dart';
import 'package:calling_app/src/features/home/presentation/rates_screen.dart';
import 'package:calling_app/src/features/home/presentation/settings_screen.dart';
import 'package:calling_app/src/features/home/presentation/wallet_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _RouterNotifier(ref),
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/verify';
      if (!authState.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }
      if (isLoggingIn) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return VerifyScreen(phone: phone);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const RatesScreen(),
          ),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/dialer',
        builder: (context, state) => const DialerScreen(),
      ),
    ],
  );
});

class _RouterNotifier extends GoRouterRefreshStream {
  _RouterNotifier(Ref ref)
      : super(ref.watch(authControllerProvider.notifier).stream);
}
