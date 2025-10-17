import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class PhoneInputView extends StatefulWidget {
  const PhoneInputView({super.key});
  @override
  State<PhoneInputView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends State<PhoneInputView> {
  final ctrl = TextEditingController(text: '+60');
  bool agreed = true;

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeSent) {
            context.go('/auth/otp', extra: state.phone);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final busy = state is AuthLoading;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone (e.g. +60...)',
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: agreed,
                      onChanged: (v) => setState(() => agreed = v ?? false),
                    ),
                    const Expanded(
                        child: Text('I agree to Terms & Conditions')),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: busy || !agreed
                      ? null
                      : () {
                          context
                              .read<AuthBloc>()
                              .add(AuthPhoneSubmitted(ctrl.text.trim()));
                        },
                  child: busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Send OTP'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Demo: use OTP 123456 on next screen',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
