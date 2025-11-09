import 'package:calling_app/src/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Language'),
            subtitle: Text('English'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const ListTile(
            title: Text('Timezone'),
            subtitle: Text('UTC'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (_) {},
            title: const Text('Dark mode'),
          ),
          ListTile(
            title: const Text('Daily spend cap'),
            subtitle: const Text('\$50.00'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Sign out'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
