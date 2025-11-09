import 'package:calling_app/src/core/utils/platform_feedback.dart';
import 'package:calling_app/src/core/widgets/platform_scaffold.dart';
import 'package:calling_app/src/features/calls/application/sip_controller.dart';
import 'package:calling_app/src/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
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
    final platform = Theme.maybeOf(context)?.platform ?? defaultTargetPlatform;
    final isCupertino = platform == TargetPlatform.iOS;
    final statusLabel =
        sip.registrationState?.state.name ?? loc.translate('status_not_registered');
    return PlatformScaffold(
      title: loc.translate('dialer_title'),
      materialActions: [
        IconButton(
          icon: const Icon(Icons.settings_phone),
          onPressed: () => _showRegisterDialog(context),
        ),
      ],
      cupertinoTrailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showRegisterDialog(context),
        child: const Icon(CupertinoIcons.phone_badge_plus),
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
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  loc.translate('status_label', params: {'status': statusLabel}),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(24),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final digit in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'])
                  _DialPadKey(
                    digit: digit,
                    isCupertino: isCupertino,
                    onTap: () => _appendDigit(digit),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: const Icon(Icons.call),
              label: Text(loc.translate('call_button')),
              onPressed: () async {
                if (_numberController.text.trim().isEmpty) {
                  showPlatformMessage(context, loc.translate('validation_phone_required'));
                  return;
                }
                try {
                  final formatted = await PhoneNumberUtil.normalizePhoneNumber(
                    _numberController.text,
                    'US',
                  );
                  await sip.makeCall(formatted ?? _numberController.text);
                } catch (err) {
                  if (!mounted) return;
                  showPlatformMessage(context, err.toString());
                }
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
    final platform = Theme.maybeOf(context)?.platform ?? defaultTargetPlatform;

    Future<void> handleSubmit(BuildContext ctx) async {
      if (domainController.text.trim().isEmpty ||
          userController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        showPlatformMessage(context, loc.translate('validation_fields_required'));
        return;
      }
      await ref.read(sipControllerProvider).register(
            domain: domainController.text,
            user: userController.text,
            password: passwordController.text,
          );
      if (!mounted) return;
      Navigator.of(ctx, rootNavigator: true).pop();
    }

    if (platform == TargetPlatform.iOS) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(loc.translate('register_sip_title')),
          content: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: domainController,
                placeholder: loc.translate('register_sip_domain'),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: userController,
                placeholder: loc.translate('register_sip_username'),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: passwordController,
                placeholder: loc.translate('register_sip_password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
              child: Text(loc.translate('cancel')),
            ),
            CupertinoDialogAction(
              onPressed: () => handleSubmit(dialogContext),
              isDefaultAction: true,
              child: Text(loc.translate('register')),
            ),
          ],
        ),
      );
      return;
    }

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
                await handleSubmit(dialogContext);
            },
            child: Text(loc.translate('register')),
          ),
        ],
      ),
    );
  }
}

class _DialPadKey extends StatelessWidget {
  const _DialPadKey({
    required this.digit,
    required this.isCupertino,
    required this.onTap,
  });

  final String digit;
  final bool isCupertino;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isCupertino) {
        return CupertinoButton(
        onPressed: onTap,
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(16),
        child: Text(
          digit,
            style: const TextStyle(fontSize: 28, color: CupertinoColors.label),
        ),
      );
    }

    return FilledButton.tonal(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        digit,
        style: const TextStyle(fontSize: 26),
      ),
    );
  }
}
