import 'package:calling_app/src/features/calls/application/sip_controller.dart';
import 'package:calling_app/src/l10n/app_localizations.dart';
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
    final loc = context.loc;
    final statusLabel =
        sip.registrationState?.state.name ?? loc.translate('status_not_registered');
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('dialer_title')),
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
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: loc.translate('phone_input_label'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(loc.translate('status_label', params: {'status': statusLabel})),
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
                  for (final digit in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'])
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
              label: Text(loc.translate('call_button')),
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
    final loc = context.loc;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.translate('register_sip_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: domainController,
              decoration: InputDecoration(labelText: loc.translate('register_sip_domain')),
            ),
            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: loc.translate('register_sip_username')),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: loc.translate('register_sip_password')),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(loc.translate('cancel')),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(sipControllerProvider).register(
                    domain: domainController.text,
                    user: userController.text,
                    password: passwordController.text,
                  );
              if (!mounted) return;
              Navigator.of(dialogContext).pop();
            },
            child: Text(loc.translate('register')),
          ),
        ],
      ),
    );
  }
}
