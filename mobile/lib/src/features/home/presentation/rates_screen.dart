import 'package:flutter/material.dart';

class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rates')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _RateTile(country: 'United States', prefix: '+1', rate: '\$0.02 / min'),
          _RateTile(country: 'India', prefix: '+91', rate: '\$0.05 / min'),
          _RateTile(country: 'Nigeria', prefix: '+234', rate: '\$0.12 / min'),
        ],
      ),
    );
  }
}

class _RateTile extends StatelessWidget {
  const _RateTile({required this.country, required this.prefix, required this.rate});

  final String country;
  final String prefix;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(country),
        subtitle: Text(prefix),
        trailing: Text(rate),
      ),
    );
  }
}
