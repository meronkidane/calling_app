import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({required this.child, super.key});

  final Widget child;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  void didUpdateWidget(covariant HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _index = _calculateSelectedIndex(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/dialer'),
        icon: const Icon(Icons.dialer_sip),
        label: const Text('Dialer'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => _onTap(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.public), label: 'Rates'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/wallet');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/wallet')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }
}
