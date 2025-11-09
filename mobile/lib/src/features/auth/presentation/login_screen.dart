import 'package:calling_app/src/features/auth/application/auth_controller.dart';
import 'package:calling_app/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String? _debugOtp;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final loc = context.loc;
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('sign_in_title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: loc.translate('phone_input_label'),
                  hintText: loc.translate('phone_input_hint'),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? loc.translate('validation_phone_required') : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(loc.translate('request_otp_button')),
                ),
              ),
              if (_debugOtp != null) ...[
                const SizedBox(height: 12),
                Text(
                  loc.translate('sandbox_otp_label', params: {'code': _debugOtp!}),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = _phoneController.text.trim();
    try {
      final otp = await ref.read(authControllerProvider.notifier).requestOtp(phone);
      if (!mounted) return;
      setState(() {
        _debugOtp = otp;
      });
      if (!mounted) return;
      context.push('/verify', extra: {'phone': phone}, queryParameters: {'phone': phone});
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.loc.translate('failed_send_otp')}: $err')),
      );
    }
  }
}
