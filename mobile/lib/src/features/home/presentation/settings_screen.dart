import 'package:calling_app/src/core/widgets/platform_scaffold.dart';
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
    final entries = [
      _SettingTile(
        icon: Icons.language,
        title: loc.translate('language_label'),
        subtitle: 'English',
        onTap: () {},
      ),
      _SettingTile(
        icon: Icons.public,
        title: loc.translate('timezone_label'),
        subtitle: 'UTC',
        onTap: () {},
      ),
      _SettingToggle(
        icon: Icons.dark_mode,
        title: loc.translate('dark_mode_label'),
        value: Theme.of(context).brightness == Brightness.dark,
        onChanged: (_) {},
      ),
      _SettingTile(
        icon: Icons.payments,
        title: loc.translate('daily_spend_cap'),
        subtitle: '\$50.00',
        onTap: () {},
      ),
    ];

    return PlatformScaffold(
      title: loc.translate('settings_title'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: entries.length + 1,
        itemBuilder: (context, index) {
          if (index < entries.length) {
            return entries[index];
          }
          return Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: Text(loc.translate('sign_out')),
              onTap: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  const _SettingToggle({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SwitchListTile(
        secondary: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
