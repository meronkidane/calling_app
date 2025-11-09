import 'package:calling_app/src/core/widgets/platform_scaffold.dart';
import 'package:calling_app/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final rates = [
      const _RateData(country: 'United States', prefix: '+1', rate: '\$0.02 / min'),
      const _RateData(country: 'India', prefix: '+91', rate: '\$0.05 / min'),
      const _RateData(country: 'Nigeria', prefix: '+234', rate: '\$0.12 / min'),
      const _RateData(country: 'Ethiopia', prefix: '+251', rate: '\$0.09 / min'),
    ];

    return PlatformScaffold(
      title: loc.translate('rates_title'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: rates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final rate = rates[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                child: Text(rate.prefix.replaceAll('+', '')),
              ),
              title: Text(rate.country, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(rate.prefix),
              trailing: Text(
                rate.rate,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RateData {
  const _RateData({
    required this.country,
    required this.prefix,
    required this.rate,
  });

  final String country;
  final String prefix;
  final String rate;
}
