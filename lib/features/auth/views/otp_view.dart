import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class OtpView extends StatefulWidget {
  final String? phone; // <— receive it here

  const OtpView({super.key, this.phone});
  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final codeCtrl = TextEditingController();

  @override
  void dispose() {
    codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.phone; // <— use this

    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go('/feed'); // ✅ navigate to feed
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final busy = state is AuthLoading;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Sending to: ${phone ?? '(unknown)'}',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                TextField(
                  controller: codeCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(labelText: '6-digit code'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () {
                          // ✅ use the same phone passed from previous screen
                          context.read<AuthBloc>().add(
                                AuthOtpSubmitted(
                                  (phone ?? '').trim(),
                                  codeCtrl.text.trim(),
                                ),
                              );
                        },
                  child: busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify & Continue'),
                ),
                const SizedBox(height: 12),
                const Text('Demo OTP is 123456',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
