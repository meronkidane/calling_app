import 'package:calling_app/src/features/auth/application/auth_controller.dart';
import 'package:calling_app/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = context.loc;
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('settings_title'))),
      body: ListView(
        children: [
          ListTile(
            title: Text(loc.translate('language_label')),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          ListTile(
            title: Text(loc.translate('timezone_label')),
            subtitle: const Text('UTC'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (_) {},
            title: Text(loc.translate('dark_mode_label')),
          ),
          ListTile(
            title: Text(loc.translate('daily_spend_cap')),
            subtitle: const Text('\$50.00'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            title: Text(loc.translate('sign_out')),
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
