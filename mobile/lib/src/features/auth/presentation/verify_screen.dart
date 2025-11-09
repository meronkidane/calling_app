import 'package:calling_app/src/core/utils/platform_feedback.dart';
import 'package:calling_app/src/core/widgets/platform_scaffold.dart';
import 'package:calling_app/src/features/auth/application/auth_controller.dart';
import 'package:calling_app/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({required this.phone, super.key});

  final String phone;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final loc = context.loc;
    final isLoading = authState.isLoading;

    return PlatformScaffold(
      title: loc.translate('verify_title'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.translate('verify_title'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              loc.translate('verify_message', params: {'phone': widget.phone}),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: loc.translate('otp_input_label'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? loc.translate('validation_code_required') : null,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(loc.translate('verify_button')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final code = _codeController.text.trim();
    try {
      await ref
          .read(authControllerProvider.notifier)
          .verifyOtp(widget.phone, code);
      if (!mounted) return;
      context.go('/home');
    } catch (err) {
      if (!mounted) return;
      showPlatformMessage(context, '${context.loc.translate('verification_failed')}: $err');
    }
  }
}
