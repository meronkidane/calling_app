import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call History')),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return const ListTile(
            leading: Icon(Icons.call_made),
            title: Text('+91 98765 43210'),
            subtitle: Text('3m 24s • \$0.18'),
            trailing: Text('Yesterday'),
          );
        },
      ),
    );
  }
}
