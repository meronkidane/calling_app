import 'package:calling_app/src/features/calls/application/sip_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libphonenumber_plugin/libphonenumber_plugin.dart';

class DialerScreen extends ConsumerStatefulWidget {
  const DialerScreen({super.key});

  @override
  ConsumerState<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends ConsumerState<DialerScreen> {
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sip = ref.watch(sipControllerProvider);
    final status = sip.registrationState?.state.name ?? 'Not registered';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_phone),
            onPressed: () => _showRegisterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _numberController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Number',
                  ),
                ),
                const SizedBox(height: 8),
                Text('Status: $status'),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(24),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                for (final digit in ['1','2','3','4','5','6','7','8','9','*','0','#'])
                  ElevatedButton(
                    onPressed: () => _appendDigit(digit),
                    child: Text(digit, style: const TextStyle(fontSize: 24)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: FilledButton.icon(
              icon: const Icon(Icons.call),
              label: const Text('Call'),
              onPressed: () async {
                final formatted = await PhoneNumberUtil.normalizePhoneNumber(
                  _numberController.text,
                  'US',
                );
                await sip.makeCall(formatted ?? _numberController.text);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _appendDigit(String digit) {
    setState(() {
      _numberController.text += digit;
    });
  }

  Future<void> _showRegisterDialog(BuildContext context) async {
    final domainController = TextEditingController();
    final userController = TextEditingController();
    final passwordController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register SIP account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: domainController,
              decoration: const InputDecoration(labelText: 'SIP domain'),
            ),
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(sipControllerProvider).register(
                    domain: domainController.text,
                    user: userController.text,
                    password: passwordController.text,
                  );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
