import 'package:calling_app/src/core/widgets/platform_scaffold.dart';
import 'package:calling_app/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return PlatformScaffold(
      title: loc.translate('wallet_title'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.translate('balance_label'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$25.00',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: Text(loc.translate('top_up_button')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              loc.translate('wallet_recent_activity'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...const [
              _WalletEntry(title: 'Top up', subtitle: 'Stripe • 2024-09-01', amount: '+\$10.00'),
              _WalletEntry(title: 'Call to India', subtitle: '+91 98765 43210', amount: '-\$0.42'),
              _WalletEntry(title: 'Call to Ethiopia', subtitle: '+251 912 345678', amount: '-\$0.30'),
            ],
          ],
        ),
      ),
    );
  }
}

class _WalletEntry extends StatelessWidget {
  const _WalletEntry({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  final String title;
  final String subtitle;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final isDebit = amount.startsWith('-');
    final color =
        isDebit ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(
            isDebit ? Icons.call_made : Icons.attach_money,
            color: color,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
        ),
      ),
    );
  }
}
