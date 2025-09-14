import 'package:flutter/material.dart';

class PhoneInputView extends StatelessWidget {
  const PhoneInputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: const Center(child: Text('Phone Input View')),
    );
  }
}
