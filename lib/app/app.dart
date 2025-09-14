import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class MalaysiaSocialApp extends StatelessWidget {
  const MalaysiaSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter();
    return MaterialApp.router(
      title: 'Malaysia Social',
      theme: buildTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
