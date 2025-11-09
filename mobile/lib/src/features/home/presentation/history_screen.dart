import 'package:calling_app/src/core/widgets/platform_scaffold.dart';
import 'package:calling_app/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final calls = [
      const _CallRecord(direction: Icons.call_made, contact: '+91 98765 43210', duration: '3m 24s', cost: '\$0.18', timestamp: 'Yesterday'),
      const _CallRecord(direction: Icons.call_received, contact: '+1 202 555 0182', duration: '10m 02s', cost: '\$0.00', timestamp: 'Yesterday'),
      const _CallRecord(direction: Icons.call_missed_outgoing, contact: '+251 912 345678', duration: '0m 00s', cost: '\$0.00', timestamp: '2 days ago'),
      const _CallRecord(direction: Icons.call_made, contact: '+44 208 123 4567', duration: '5m 12s', cost: '\$0.36', timestamp: '2 days ago'),
    ];

    return PlatformScaffold(
      title: loc.translate('history_title'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: calls.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final call = calls[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(call.direction, color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              title: Text(call.contact),
              subtitle: Text('${call.duration} • ${call.cost}'),
              trailing: Text(call.timestamp, style: Theme.of(context).textTheme.bodySmall),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

class _CallRecord {
  const _CallRecord({
    required this.direction,
    required this.contact,
    required this.duration,
    required this.cost,
    required this.timestamp,
  });

  final IconData direction;
  final String contact;
  final String duration;
  final String cost;
  final String timestamp;
}
